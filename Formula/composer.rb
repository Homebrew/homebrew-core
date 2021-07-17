class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.1.3/composer.phar"
  sha256 "f8a72e98dec8da736d8dac66761ca0a8fbde913753e9a43f34112367f5174d11"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7ce70237cec9f4a40aa1ea6917d40258c010bf59b47026f32d0b31ede8c49188"
    sha256 cellar: :any_skip_relocation, big_sur:       "4c852f706d4ead18bb1cf79a972783b169fa52ce24c348a1d5dd349db5b6f404"
    sha256 cellar: :any_skip_relocation, catalina:      "4c852f706d4ead18bb1cf79a972783b169fa52ce24c348a1d5dd349db5b6f404"
    sha256 cellar: :any_skip_relocation, mojave:        "4c852f706d4ead18bb1cf79a972783b169fa52ce24c348a1d5dd349db5b6f404"
  end

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  pour_bottle? do
    on_macos do
      reason "The bottle needs to be installed into `#{Homebrew::DEFAULT_PREFIX}` on Intel macOS."
      satisfy { HOMEBREW_PREFIX.to_s == Homebrew::DEFAULT_PREFIX || Hardware::CPU.arm? }
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

    (testpath/"src/HelloWorld/greetings.php").write <<~EOS
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
