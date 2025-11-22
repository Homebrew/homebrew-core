class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.9.2/composer.phar"
  sha256 "471f2d857abf0ec18af7b055e61472214d91adb24f9bdbbb864c1c64faad7dd6"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7259e23d91919ebc2d4e33ee9928dc7f67b6e85ff2f03df0b42001da072eb437"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7259e23d91919ebc2d4e33ee9928dc7f67b6e85ff2f03df0b42001da072eb437"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7259e23d91919ebc2d4e33ee9928dc7f67b6e85ff2f03df0b42001da072eb437"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fd0371d5fb55a0a9a083f1e9560336b38c1595d2638b610b4754d33760b4456"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fd0371d5fb55a0a9a083f1e9560336b38c1595d2638b610b4754d33760b4456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fd0371d5fb55a0a9a083f1e9560336b38c1595d2638b610b4754d33760b4456"
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
