class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.11.2/composer.phar"
  sha256 "dd158c0afd41d15fac89e1b4e47b5d42911fe316c3687cd5edac98319b25d028"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b20501dd62be7d12f01e0e14d659ae21d79ee37fccbba0e89bd92de88c4cb509"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b20501dd62be7d12f01e0e14d659ae21d79ee37fccbba0e89bd92de88c4cb509"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b20501dd62be7d12f01e0e14d659ae21d79ee37fccbba0e89bd92de88c4cb509"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7ba513596837354ea885577a16ce84512bef5b397588dbfeda56d38e647eee5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7ba513596837354ea885577a16ce84512bef5b397588dbfeda56d38e647eee5b"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces the prefix with a non-default value
  on_macos do
    pour_bottle? only_if: :default_prefix
  end

  allow_network_access! :test

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
