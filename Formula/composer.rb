class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.4.0/composer.phar"
  sha256 "1cdc74f74965908d0e98d00feeca37c23b86da51170a3a11a1538d89ff44d4dd"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f68e722805ab8dd4424c2d16cac1406a1d792ae888f96abef37e8f64ea20b75f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f68e722805ab8dd4424c2d16cac1406a1d792ae888f96abef37e8f64ea20b75f"
    sha256 cellar: :any_skip_relocation, monterey:       "a02937f59cb86834e35bb102bf588e83377253d3e25bd730378a0747a6da790e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a02937f59cb86834e35bb102bf588e83377253d3e25bd730378a0747a6da790e"
    sha256 cellar: :any_skip_relocation, catalina:       "a02937f59cb86834e35bb102bf588e83377253d3e25bd730378a0747a6da790e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f68e722805ab8dd4424c2d16cac1406a1d792ae888f96abef37e8f64ea20b75f"
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
