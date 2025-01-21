class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.8.4/composer.phar"
  sha256 "c4c4e2e1beab0ea04e0bd042a5dbba9feda1fbf5eda0d36203958edd343c0a8a"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85fa1c6cf94a5f2e447ff708b0f6ee3a0bfbd86925aface29bb16c7a36ed9648"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85fa1c6cf94a5f2e447ff708b0f6ee3a0bfbd86925aface29bb16c7a36ed9648"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85fa1c6cf94a5f2e447ff708b0f6ee3a0bfbd86925aface29bb16c7a36ed9648"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3e89bceaf78a4b75f634406844d209967cd1d63f90c3acea6e143a58086a094"
    sha256 cellar: :any_skip_relocation, ventura:       "a3e89bceaf78a4b75f634406844d209967cd1d63f90c3acea6e143a58086a094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dcad5f8b0f77587937cf56c485f660742873919cd24bd05548da8d7ffe1b201"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "composer.phar" => "composer"
  end

  test do
    (testpath/"composer.json").write <<~JSON
      {
        "name": "homebrew/test",
        "authors": [
          {
            "name": "Homebrew"
          }
        ],
        "require": {
          "php": ">=5.3.4"
          },
        "autoload": {
          "psr-0": {
            "HelloWorld": "src/"
          }
        }
      }
    JSON

    (testpath/"src/HelloWorld/Greetings.php").write <<~PHP
      <?php

      namespace HelloWorld;

      class Greetings {
        public static function sayHelloWorld() {
          return 'HelloHomebrew';
        }
      }
    PHP

    (testpath/"tests/test.php").write <<~PHP
      <?php

      // Autoload files using the Composer autoloader.
      require_once __DIR__ . '/../vendor/autoload.php';

      use HelloWorld\\Greetings;

      echo Greetings::sayHelloWorld();
    PHP

    system bin/"composer", "install"
    assert_match(/^HelloHomebrew$/, shell_output("php tests/test.php"))
  end
end
