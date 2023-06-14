class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.5.8/composer.phar"
  sha256 "f07934fad44f9048c0dc875a506cca31cc2794d6aebfc1867f3b1fbf48dce2c5"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e07159116be2cb513cd08201b92c084cff093b78c115c1a00518a454aab9f309"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e07159116be2cb513cd08201b92c084cff093b78c115c1a00518a454aab9f309"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e07159116be2cb513cd08201b92c084cff093b78c115c1a00518a454aab9f309"
    sha256 cellar: :any_skip_relocation, ventura:        "9deba5a92bfacce1788651462f34514001c81daee7d8bef18c88b6d33de6a01c"
    sha256 cellar: :any_skip_relocation, monterey:       "9deba5a92bfacce1788651462f34514001c81daee7d8bef18c88b6d33de6a01c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9deba5a92bfacce1788651462f34514001c81daee7d8bef18c88b6d33de6a01c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e07159116be2cb513cd08201b92c084cff093b78c115c1a00518a454aab9f309"
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
