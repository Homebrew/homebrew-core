class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.1.6/composer.phar"
  sha256 "72524ccebcb071968eb83284507225fdba59f223719b2b3f333d76c8a9ac6b72"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2b4fec192c3276fc11f9c4bb593e7a28d42e1139107b7517377998f4040591ee"
    sha256 cellar: :any_skip_relocation, big_sur:       "ded5ca31c045db4fa534d30a45ebea8b5aca70e31e32361b34565377b267ab14"
    sha256 cellar: :any_skip_relocation, catalina:      "ded5ca31c045db4fa534d30a45ebea8b5aca70e31e32361b34565377b267ab14"
    sha256 cellar: :any_skip_relocation, mojave:        "ded5ca31c045db4fa534d30a45ebea8b5aca70e31e32361b34565377b267ab14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b4fec192c3276fc11f9c4bb593e7a28d42e1139107b7517377998f4040591ee"
  end

  uses_from_macos "php"

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
