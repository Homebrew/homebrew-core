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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0563880e95063f6b76206668ca3bf88b33b3cf7a0d539e80fd8c164099ed3cc5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0563880e95063f6b76206668ca3bf88b33b3cf7a0d539e80fd8c164099ed3cc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0563880e95063f6b76206668ca3bf88b33b3cf7a0d539e80fd8c164099ed3cc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "48ee63b1aa16aeb1d0b818d16bfd20c90644b6a7723386e10eb9b6c87645cbaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "48ee63b1aa16aeb1d0b818d16bfd20c90644b6a7723386e10eb9b6c87645cbaa"
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
