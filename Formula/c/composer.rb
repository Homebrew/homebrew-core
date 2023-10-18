class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.6.5/composer.phar"
  sha256 "9a18e1a3aadbcb94c1bafd6c4a98ff931f4b43a456ef48575130466e19f05dd6"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15002e3a57941cded74e470dd3145c4803668abbed515b8c6c09073f81575e13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15002e3a57941cded74e470dd3145c4803668abbed515b8c6c09073f81575e13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15002e3a57941cded74e470dd3145c4803668abbed515b8c6c09073f81575e13"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfb2a11f693433805e1be7f9e440be96565df2755234f1e03f6f0791f36321f0"
    sha256 cellar: :any_skip_relocation, ventura:        "bfb2a11f693433805e1be7f9e440be96565df2755234f1e03f6f0791f36321f0"
    sha256 cellar: :any_skip_relocation, monterey:       "bfb2a11f693433805e1be7f9e440be96565df2755234f1e03f6f0791f36321f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15002e3a57941cded74e470dd3145c4803668abbed515b8c6c09073f81575e13"
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
