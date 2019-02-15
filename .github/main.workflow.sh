#!/bin/bash

set -e

# take ownership as current user (in case it's linuxbrew)
sudo mkdir ~/.cache
sudo chown -R $USER . ~/.cache

# create stubs so build dependencies aren't incorrectly flagged as missing
for i in python svn unzip xz
do
  sudo touch /usr/bin/$i
  sudo chmod +x /usr/bin/$i
done

# tap Homebrew/homebrew-core instead of Linuxbrew's
rm -rf "$(brew --repo homebrew/core)"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_FORCE_HOMEBREW_ON_LINUX=1
export PATH="$(brew --repo)/Library/Homebrew/vendor/portable-ruby/current/bin:$PATH"
brew tap homebrew/core

# clone formulae.brew.sh with token so we can push back
git clone https://$GITHUB_TOKEN@github.com/Homebrew/formulae.brew.sh

# TODO: setup/decrypt analytics JSON
#openssl aes-256-cbc -K $encrypted_973277d8afbb_key -iv $encrypted_973277d8afbb_iv -in formulae.brew.sh/.homebrew_analytics.json.enc -out formulae.brew.sh/.homebrew_analytics.json -d

cd formulae.brew.sh

# run rake (without a rake binary)
ruby -e "load Gem.bin_path('rake', 'rake')"
