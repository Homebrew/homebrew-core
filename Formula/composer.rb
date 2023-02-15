class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.5.4/composer.phar"
  sha256 "91ce6cbf9463eae86ae9d5c21d42faa601a519f3fbb2b623a55ee24678079bd3"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c7cf469b14b68d6a73a7f51acccf24dcbfc6897a14bfdb8af12066b525b448b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c7cf469b14b68d6a73a7f51acccf24dcbfc6897a14bfdb8af12066b525b448b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c7cf469b14b68d6a73a7f51acccf24dcbfc6897a14bfdb8af12066b525b448b"
    sha256 cellar: :any_skip_relocation, ventura:        "a5f368b6207d02127fc485b209aabad9b4634ff000613ff45a224cd251fbb166"
    sha256 cellar: :any_skip_relocation, monterey:       "a5f368b6207d02127fc485b209aabad9b4634ff000613ff45a224cd251fbb166"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5f368b6207d02127fc485b209aabad9b4634ff000613ff45a224cd251fbb166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c7cf469b14b68d6a73a7f51acccf24dcbfc6897a14bfdb8af12066b525b448b"
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
