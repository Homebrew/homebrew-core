class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.7.2/composer.phar"
  sha256 "049b8e0ed9f264d770a0510858cffbc35401510759edc9a784b3a5c6e020bcac"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf679c49688940af731c0a07fb4cbbd148fe6973762e2c1fd499820e59c6be1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf679c49688940af731c0a07fb4cbbd148fe6973762e2c1fd499820e59c6be1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf679c49688940af731c0a07fb4cbbd148fe6973762e2c1fd499820e59c6be1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "234eff3b59a2705815b11bc2768ea8bb7e877d94adf9815e084a1237f70dc2bb"
    sha256 cellar: :any_skip_relocation, ventura:        "234eff3b59a2705815b11bc2768ea8bb7e877d94adf9815e084a1237f70dc2bb"
    sha256 cellar: :any_skip_relocation, monterey:       "234eff3b59a2705815b11bc2768ea8bb7e877d94adf9815e084a1237f70dc2bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5af5f6c77a77b0fdfba04bbcb5ea2882626e2a8c3fa7a8c0b73b77ec0583863"
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
