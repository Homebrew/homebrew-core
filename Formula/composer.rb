class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.2.0/composer.phar"
  sha256 "f7928b5465ad14c49901174d72c701d74ee278479ae19a44f6a46839e2d87d4d"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a5935135030a1c5c160274179271a78961f9e2dcac93d97bfe6a9633368ed6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a5935135030a1c5c160274179271a78961f9e2dcac93d97bfe6a9633368ed6f"
    sha256 cellar: :any_skip_relocation, monterey:       "02f5fed3d67b82fb827078ffcd486a4a455d1f94e94d0701d779238d4e10903e"
    sha256 cellar: :any_skip_relocation, big_sur:        "02f5fed3d67b82fb827078ffcd486a4a455d1f94e94d0701d779238d4e10903e"
    sha256 cellar: :any_skip_relocation, catalina:       "02f5fed3d67b82fb827078ffcd486a4a455d1f94e94d0701d779238d4e10903e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a5935135030a1c5c160274179271a78961f9e2dcac93d97bfe6a9633368ed6f"
  end

  depends_on "php"

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
