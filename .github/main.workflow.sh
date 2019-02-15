#!/bin/bash

set -e

git clone https://$GITHUB_TOKEN@github.com/Homebrew/formulae.brew.sh
cd formulae.brew.sh
git fetch
rake
