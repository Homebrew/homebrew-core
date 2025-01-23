class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.8.5/composer.phar"
  sha256 "9cef18212e222351aeb476b81de7b2a5383f775336474467bf5c7ccfe84ab0cc"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3be8b1d9eef803f6f102d3ea027f6495cd9dccd39a904c5cf9b91ee64c67a53c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3be8b1d9eef803f6f102d3ea027f6495cd9dccd39a904c5cf9b91ee64c67a53c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3be8b1d9eef803f6f102d3ea027f6495cd9dccd39a904c5cf9b91ee64c67a53c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca89a52c5a4d3f2b48c7ad0570199fff153a5a1c06e5830c6a6bedafd98f5ec6"
    sha256 cellar: :any_skip_relocation, ventura:       "ca89a52c5a4d3f2b48c7ad0570199fff153a5a1c06e5830c6a6bedafd98f5ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "280f7da2db2db2f2ab2327885cad084a2d5e4a213fc3c113ec096c63592a6b0e"
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
