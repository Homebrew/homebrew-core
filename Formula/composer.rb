class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.1.5/composer.phar"
  sha256 "be95557cc36eeb82da0f4340a469bad56b57f742d2891892dcb2f8b0179790ec"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "71f3a9db24f8a1771666a548c53530df110aff7b522b5df7f6fcd293223b2036"
    sha256 cellar: :any_skip_relocation, big_sur:       "7c7bdb27d4f70bfd39bcf266e59652a736d7104bd0757a8194ea07357be70755"
    sha256 cellar: :any_skip_relocation, catalina:      "7c7bdb27d4f70bfd39bcf266e59652a736d7104bd0757a8194ea07357be70755"
    sha256 cellar: :any_skip_relocation, mojave:        "7c7bdb27d4f70bfd39bcf266e59652a736d7104bd0757a8194ea07357be70755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71f3a9db24f8a1771666a548c53530df110aff7b522b5df7f6fcd293223b2036"
  end

  uses_from_macos "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
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
