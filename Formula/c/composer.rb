class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.8.12/composer.phar"
  sha256 "f446ea719708bb85fcbf4ef18def5d0515f1f9b4d703f6d820c9c1656e10a2f2"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42978dd11168f2f7f1a564fe4a9a784d1c365f21be2d1f249b612af2f10562ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42978dd11168f2f7f1a564fe4a9a784d1c365f21be2d1f249b612af2f10562ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42978dd11168f2f7f1a564fe4a9a784d1c365f21be2d1f249b612af2f10562ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "4019389d975b1ed145a9f9ea3800fb9261f707beca864b20b3dffb12e23d8c7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4019389d975b1ed145a9f9ea3800fb9261f707beca864b20b3dffb12e23d8c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4019389d975b1ed145a9f9ea3800fb9261f707beca864b20b3dffb12e23d8c7b"
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
    (testpath/"composer.json").write <<~JSON
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
    JSON

    (testpath/"src/HelloWorld/Greetings.php").write <<~PHP
      <?php

      namespace HelloWorld;

      class Greetings {
        public static function sayHelloWorld() {
          return 'HelloHomebrew';
        }
      }
    PHP

    (testpath/"tests/test.php").write <<~PHP
      <?php

      // Autoload files using the Composer autoloader.
      require_once __DIR__ . '/../vendor/autoload.php';

      use HelloWorld\\Greetings;

      echo Greetings::sayHelloWorld();
    PHP

    system bin/"composer", "install"
    assert_match(/^HelloHomebrew$/, shell_output("php tests/test.php"))
  end
end
