class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.3.3/composer.phar"
  sha256 "d6931ec2b38b41bd0ad62f9d157908e6688bac091bbf0bd6a619c1067b922402"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4b7bdbe465ccbe3734cc3a845597ca23d86b2d270538929c22427e0e14f71cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4b7bdbe465ccbe3734cc3a845597ca23d86b2d270538929c22427e0e14f71cc"
    sha256 cellar: :any_skip_relocation, monterey:       "1a1c3cad1b4efc8961369b21fe105d286b1fa7325a484b1348f4f3844170856f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a1c3cad1b4efc8961369b21fe105d286b1fa7325a484b1348f4f3844170856f"
    sha256 cellar: :any_skip_relocation, catalina:       "1a1c3cad1b4efc8961369b21fe105d286b1fa7325a484b1348f4f3844170856f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4b7bdbe465ccbe3734cc3a845597ca23d86b2d270538929c22427e0e14f71cc"
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
