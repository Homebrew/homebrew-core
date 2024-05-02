class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.7.4/composer.phar"
  sha256 "ee01080d632d2bbfa9c618009cca13718f36e751dda679a6009cee751c13b2d9"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "899df19cff4dad20b80d445d40249c13cf7cdb628955c3dff2692c2d3d5d6cde"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "899df19cff4dad20b80d445d40249c13cf7cdb628955c3dff2692c2d3d5d6cde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "899df19cff4dad20b80d445d40249c13cf7cdb628955c3dff2692c2d3d5d6cde"
    sha256 cellar: :any_skip_relocation, sonoma:         "a735d4935b3fa97876acbfc3718416f77bb6ecd38714d88264f115a71a6e14c2"
    sha256 cellar: :any_skip_relocation, ventura:        "a735d4935b3fa97876acbfc3718416f77bb6ecd38714d88264f115a71a6e14c2"
    sha256 cellar: :any_skip_relocation, monterey:       "a735d4935b3fa97876acbfc3718416f77bb6ecd38714d88264f115a71a6e14c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7433a31fe30dde15e412b5dc3153c6aeaf523facd2ce0b57d3ff5eb1972c455"
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
