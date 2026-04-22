class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.9.7/composer.phar"
  sha256 "d3c6801ea6e5dd291d0f149295a4d0f1539a74d5231958fe8fdaa889a497e6cf"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2ccf50a27ea0643772b63a056801047388f211c6a9238b4651c47e8e5d96717"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2ccf50a27ea0643772b63a056801047388f211c6a9238b4651c47e8e5d96717"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2ccf50a27ea0643772b63a056801047388f211c6a9238b4651c47e8e5d96717"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b05f880c3c5ee1171aa7859e3969ec4d314eda26fd27afc54d2f60421573b99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b05f880c3c5ee1171aa7859e3969ec4d314eda26fd27afc54d2f60421573b99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b05f880c3c5ee1171aa7859e3969ec4d314eda26fd27afc54d2f60421573b99"
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
