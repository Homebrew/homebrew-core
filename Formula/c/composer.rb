class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.9.8/composer.phar"
  sha256 "59b2c50e10cafa0d8efc19ede9a326d782f096c674a26baf98cf042ce23de890"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5a24aff23970ace3bcaf7592c0a29348ecf7d5a3263ddcc69f68020380b5f81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5a24aff23970ace3bcaf7592c0a29348ecf7d5a3263ddcc69f68020380b5f81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5a24aff23970ace3bcaf7592c0a29348ecf7d5a3263ddcc69f68020380b5f81"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3707d31956862864bd9bd983b7748e2dd4ca76b53dc4a1adbb3055a7396816d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3707d31956862864bd9bd983b7748e2dd4ca76b53dc4a1adbb3055a7396816d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3707d31956862864bd9bd983b7748e2dd4ca76b53dc4a1adbb3055a7396816d"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces the prefix with a non-default value
  on_macos do
    pour_bottle? only_if: :default_prefix
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
