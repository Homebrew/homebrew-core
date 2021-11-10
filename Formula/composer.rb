class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.1.12/composer.phar"
  sha256 "ae3ec292dd04b4e468aea1e5db4d085f169d8a803aabeb99707f69e9454bf218"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8456f9ef766bfe290241a5dce114923b66d0b25f46e683a157463381b08685c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8456f9ef766bfe290241a5dce114923b66d0b25f46e683a157463381b08685c8"
    sha256 cellar: :any_skip_relocation, monterey:       "4b3e4fca1c26ac8eb6abbdcbf995130f5f78e6a4f9087b8de738b8e7ae3de11a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b3e4fca1c26ac8eb6abbdcbf995130f5f78e6a4f9087b8de738b8e7ae3de11a"
    sha256 cellar: :any_skip_relocation, catalina:       "4b3e4fca1c26ac8eb6abbdcbf995130f5f78e6a4f9087b8de738b8e7ae3de11a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8456f9ef766bfe290241a5dce114923b66d0b25f46e683a157463381b08685c8"
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
