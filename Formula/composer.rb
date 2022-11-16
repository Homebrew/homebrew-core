class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.4.4/composer.phar"
  sha256 "c252c2a2219956f88089ffc242b42c8cb9300a368fd3890d63940e4fc9652345"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ae9fc450838971810a7978f450eb102a16a6ee06506ed58547248660e17eebf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ae9fc450838971810a7978f450eb102a16a6ee06506ed58547248660e17eebf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ae9fc450838971810a7978f450eb102a16a6ee06506ed58547248660e17eebf"
    sha256 cellar: :any_skip_relocation, ventura:        "96e8cbaa4b420f4c36cd853966e6f6684e5da8fce319901ee44f1a56c6eb92f5"
    sha256 cellar: :any_skip_relocation, monterey:       "96e8cbaa4b420f4c36cd853966e6f6684e5da8fce319901ee44f1a56c6eb92f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "96e8cbaa4b420f4c36cd853966e6f6684e5da8fce319901ee44f1a56c6eb92f5"
    sha256 cellar: :any_skip_relocation, catalina:       "96e8cbaa4b420f4c36cd853966e6f6684e5da8fce319901ee44f1a56c6eb92f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ae9fc450838971810a7978f450eb102a16a6ee06506ed58547248660e17eebf"
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
