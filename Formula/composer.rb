class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.3.2/composer.phar"
  sha256 "8ec134fe04ee52cd6465384c535ec61107368d4866ade9e995dcb96d8676f0c3"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b3a9d45258013355c5a9a68c343dc776dfc7e93176ed9a4b22948d9d4a7a833"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b3a9d45258013355c5a9a68c343dc776dfc7e93176ed9a4b22948d9d4a7a833"
    sha256 cellar: :any_skip_relocation, monterey:       "6b9a5179dce2333240a66af1e6698e0745c7d0154ff4f7e357d0d0632a16918c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b9a5179dce2333240a66af1e6698e0745c7d0154ff4f7e357d0d0632a16918c"
    sha256 cellar: :any_skip_relocation, catalina:       "6b9a5179dce2333240a66af1e6698e0745c7d0154ff4f7e357d0d0632a16918c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b3a9d45258013355c5a9a68c343dc776dfc7e93176ed9a4b22948d9d4a7a833"
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
