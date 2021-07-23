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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3c77ce6a7dd0171cf2a033efb7f9488f5fc21e1e92068b78f74e5b7f692c3a94"
    sha256 cellar: :any_skip_relocation, big_sur:       "8d81770feacaaa52e670ee68824c1786f6280c52028fc4befbff6ace4ff175ec"
    sha256 cellar: :any_skip_relocation, catalina:      "8d81770feacaaa52e670ee68824c1786f6280c52028fc4befbff6ace4ff175ec"
    sha256 cellar: :any_skip_relocation, mojave:        "8d81770feacaaa52e670ee68824c1786f6280c52028fc4befbff6ace4ff175ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c77ce6a7dd0171cf2a033efb7f9488f5fc21e1e92068b78f74e5b7f692c3a94"
  end

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  pour_bottle? do
    on_macos do
      reason "The bottle needs to be installed into `#{Homebrew::DEFAULT_PREFIX}` on Intel macOS."
      satisfy { HOMEBREW_PREFIX.to_s == Homebrew::DEFAULT_PREFIX || Hardware::CPU.arm? }
    end
  end

  uses_from_macos "php"

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
