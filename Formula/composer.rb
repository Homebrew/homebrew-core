class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.4.3/composer.phar"
  sha256 "26d72f2790502bc9b22209e1cec1e0e43d33b368606ad227d327cccb388b609a"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46f55289dc508424d73e341ff9dc197e8e06b1b9b0535b3ae4947534e2123ea6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46f55289dc508424d73e341ff9dc197e8e06b1b9b0535b3ae4947534e2123ea6"
    sha256 cellar: :any_skip_relocation, monterey:       "5a8aa64099fdfeb9201132e36f580287906c8e2d55e804104319d476f10cd936"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a8aa64099fdfeb9201132e36f580287906c8e2d55e804104319d476f10cd936"
    sha256 cellar: :any_skip_relocation, catalina:       "5a8aa64099fdfeb9201132e36f580287906c8e2d55e804104319d476f10cd936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46f55289dc508424d73e341ff9dc197e8e06b1b9b0535b3ae4947534e2123ea6"
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
