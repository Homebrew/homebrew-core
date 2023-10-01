class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.6.3/composer.phar"
  sha256 "e58a390cac0df45ccf5a3d95ae94fa239eded8b7907fa2c8f752f020304fc9b1"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e69c8ccba062f1049717ce26ecf500ba70ac06c3a62978aba764a63b81027c7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e69c8ccba062f1049717ce26ecf500ba70ac06c3a62978aba764a63b81027c7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e69c8ccba062f1049717ce26ecf500ba70ac06c3a62978aba764a63b81027c7b"
    sha256 cellar: :any_skip_relocation, ventura:        "a0cea852bd0a0942b5c3c64f9144fc3520a95a18966b09b69a81c8a6e1603b34"
    sha256 cellar: :any_skip_relocation, monterey:       "a0cea852bd0a0942b5c3c64f9144fc3520a95a18966b09b69a81c8a6e1603b34"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0cea852bd0a0942b5c3c64f9144fc3520a95a18966b09b69a81c8a6e1603b34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e69c8ccba062f1049717ce26ecf500ba70ac06c3a62978aba764a63b81027c7b"
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

    system "#{bin}/composer", "install"
    assert_match(/^HelloHomebrew$/, shell_output("php tests/test.php"))
  end
end
