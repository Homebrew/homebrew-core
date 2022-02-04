class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.2.6/composer.phar"
  sha256 "1d58486b891e59e9e064c0d54bb38538f74d6014f75481542c69ad84d4e97704"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e21d21fbdc63220e0f6f3f5ea502e6d8e11a3cf58f8f4335c4368d4c55169a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e21d21fbdc63220e0f6f3f5ea502e6d8e11a3cf58f8f4335c4368d4c55169a3"
    sha256 cellar: :any_skip_relocation, monterey:       "c9ff1b89d80073f1380635ccdc18d132545bc4c0abdfa49fcfd7ce4f2d6cafc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9ff1b89d80073f1380635ccdc18d132545bc4c0abdfa49fcfd7ce4f2d6cafc7"
    sha256 cellar: :any_skip_relocation, catalina:       "c9ff1b89d80073f1380635ccdc18d132545bc4c0abdfa49fcfd7ce4f2d6cafc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e21d21fbdc63220e0f6f3f5ea502e6d8e11a3cf58f8f4335c4368d4c55169a3"
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
