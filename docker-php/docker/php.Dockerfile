FROM php:7.2-fpm

# Copy composer file if exists
# COPY composer.lock composer.json /var/www/

WORKDIR /var/www

# Install dependencies
RUN apt-get update -y && apt-get install -y \
    build-essential \
    locales \
    unzip \
    zip \
    zlib1g-dev \
    curl

# Clear cache
RUN apt-get autoclean -y && apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install php extensions
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl zip

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

COPY . /var/www
COPY --chown=www:www . /var/www
USER www

EXPOSE 9000
CMD ["php-fpm"]
