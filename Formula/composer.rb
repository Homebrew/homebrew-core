class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.3.0/composer.phar"
  sha256 "07d7d2adeaccd97eefa96c26bc6742b465b808b77bbf4246cf2b556970c2bcb1"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a752a129066d7fef5596ca734e82c8def5525ed299659700f16c53d6299f6d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a752a129066d7fef5596ca734e82c8def5525ed299659700f16c53d6299f6d8"
    sha256 cellar: :any_skip_relocation, monterey:       "b2e847d900823756198aac270cae405e8e0b92dcf026fbab1193de707263acb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2e847d900823756198aac270cae405e8e0b92dcf026fbab1193de707263acb1"
    sha256 cellar: :any_skip_relocation, catalina:       "b2e847d900823756198aac270cae405e8e0b92dcf026fbab1193de707263acb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a752a129066d7fef5596ca734e82c8def5525ed299659700f16c53d6299f6d8"
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
