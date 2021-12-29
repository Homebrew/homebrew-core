class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.2.2/composer.phar"
  sha256 "7391e020cd3ed1a158fd6cfc0b79d7c005854396536b5499e58fc6eedb544b4e"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb888f3ee265e9d3ee2fa9d73504757e8d25188fadeb6a970645eaaf8fd7b344"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb888f3ee265e9d3ee2fa9d73504757e8d25188fadeb6a970645eaaf8fd7b344"
    sha256 cellar: :any_skip_relocation, monterey:       "e0a59e2c8587b0133ecb09fb38ebf10c50e68434d7fe43b8483223aa5f37457c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0a59e2c8587b0133ecb09fb38ebf10c50e68434d7fe43b8483223aa5f37457c"
    sha256 cellar: :any_skip_relocation, catalina:       "e0a59e2c8587b0133ecb09fb38ebf10c50e68434d7fe43b8483223aa5f37457c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb888f3ee265e9d3ee2fa9d73504757e8d25188fadeb6a970645eaaf8fd7b344"
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
