class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.2.10/composer.phar"
  sha256 "dc9dfdd2ffb1180d785b5a3d581c946ec6da135f55c9959f21b96fea7d7fb12d"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a2f0ef6df194b3874f9952960a12e83e21e5291ad63040baa0f26bff9fd272b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a2f0ef6df194b3874f9952960a12e83e21e5291ad63040baa0f26bff9fd272b"
    sha256 cellar: :any_skip_relocation, monterey:       "934fa9823a140d1c5334134810ef3e6e8662ee008207092bcd80c143a1a8c9b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "934fa9823a140d1c5334134810ef3e6e8662ee008207092bcd80c143a1a8c9b0"
    sha256 cellar: :any_skip_relocation, catalina:       "934fa9823a140d1c5334134810ef3e6e8662ee008207092bcd80c143a1a8c9b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a2f0ef6df194b3874f9952960a12e83e21e5291ad63040baa0f26bff9fd272b"
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
