class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.3.10/composer.phar"
  sha256 "d808272f284fa8e0f8b470703e1438ac8f362030bbc9d12e29530277d767aff0"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2cac9c545b2665949f22f8fe7eb016a44db54e1e0b73280bdc55238bd34ac42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2cac9c545b2665949f22f8fe7eb016a44db54e1e0b73280bdc55238bd34ac42"
    sha256 cellar: :any_skip_relocation, monterey:       "ebb1d038ff5ebbd5dd947592c17328d6d9da3005dfeeb8634e87463478c86710"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebb1d038ff5ebbd5dd947592c17328d6d9da3005dfeeb8634e87463478c86710"
    sha256 cellar: :any_skip_relocation, catalina:       "ebb1d038ff5ebbd5dd947592c17328d6d9da3005dfeeb8634e87463478c86710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2cac9c545b2665949f22f8fe7eb016a44db54e1e0b73280bdc55238bd34ac42"
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
