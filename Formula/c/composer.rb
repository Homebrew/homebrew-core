class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.7.7/composer.phar"
  sha256 "aab940cd53d285a54c50465820a2080fcb7182a4ba1e5f795abfb10414a4b4be"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a878ab2c5f0a7cc3dc11b49b33b1627e16dde21e76a5222e787d1c656fa6aafb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a878ab2c5f0a7cc3dc11b49b33b1627e16dde21e76a5222e787d1c656fa6aafb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a878ab2c5f0a7cc3dc11b49b33b1627e16dde21e76a5222e787d1c656fa6aafb"
    sha256 cellar: :any_skip_relocation, sonoma:         "64bc13abdf6b18fcad1a3b9d2ce910526b690240c2c54f21f145ca9c4e679070"
    sha256 cellar: :any_skip_relocation, ventura:        "64bc13abdf6b18fcad1a3b9d2ce910526b690240c2c54f21f145ca9c4e679070"
    sha256 cellar: :any_skip_relocation, monterey:       "64bc13abdf6b18fcad1a3b9d2ce910526b690240c2c54f21f145ca9c4e679070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0a52f38e9003c8b16117222d6b61e6e1b61fbb3751a30e472fc13620ed098ea"
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
    (testpath/"composer.json").write <<~EOS
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
    EOS

    (testpath/"src/HelloWorld/Greetings.php").write <<~EOS
      <?php

      namespace HelloWorld;

      class Greetings {
        public static function sayHelloWorld() {
          return 'HelloHomebrew';
        }
      }
    EOS

    (testpath/"tests/test.php").write <<~EOS
      <?php

      // Autoload files using the Composer autoloader.
      require_once __DIR__ . '/../vendor/autoload.php';

      use HelloWorld\\Greetings;

      echo Greetings::sayHelloWorld();
    EOS

    system bin/"composer", "install"
    assert_match(/^HelloHomebrew$/, shell_output("php tests/test.php"))
  end
end
