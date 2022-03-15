class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.2.8/composer.phar"
  sha256 "e1e1c580a237c739ecc1be57cf512e6b741faaa566439257d19ecd739ddfefaf"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cf3c6daa22a5d869ea1b8a673e7752cd2b63e27a74d3a334f0e8dda887c6018"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cf3c6daa22a5d869ea1b8a673e7752cd2b63e27a74d3a334f0e8dda887c6018"
    sha256 cellar: :any_skip_relocation, monterey:       "34070d0e7467447054ea6014f6a02652656d8893199a932126f13eae2f21c962"
    sha256 cellar: :any_skip_relocation, big_sur:        "34070d0e7467447054ea6014f6a02652656d8893199a932126f13eae2f21c962"
    sha256 cellar: :any_skip_relocation, catalina:       "34070d0e7467447054ea6014f6a02652656d8893199a932126f13eae2f21c962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cf3c6daa22a5d869ea1b8a673e7752cd2b63e27a74d3a334f0e8dda887c6018"
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
