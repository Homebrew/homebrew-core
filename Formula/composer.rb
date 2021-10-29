class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.1.10/composer.phar"
  sha256 "cb8b04cc6a6fb167403f7495e8539650eb555657aa48873f115383bcd8f0b18d"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "52ca244e1d7f289ef1bd318d2df34bad9c2d2843ad81e26111c87eab62b32834"
    sha256 cellar: :any_skip_relocation, big_sur:       "9b23761fd85b7bf513bd30d7dd78aee832045670bd4481f75367f6e0cac75428"
    sha256 cellar: :any_skip_relocation, catalina:      "9b23761fd85b7bf513bd30d7dd78aee832045670bd4481f75367f6e0cac75428"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52ca244e1d7f289ef1bd318d2df34bad9c2d2843ad81e26111c87eab62b32834"
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
