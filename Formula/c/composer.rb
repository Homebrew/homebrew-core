class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.6.6/composer.phar"
  sha256 "72600201c73c7c4b218f1c0511b36d8537963e36aafa244757f52309f885b314"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca0b1c79f84e5bc71dbeae34761ccec081331cbebf6b5893c9af9f52873213ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca0b1c79f84e5bc71dbeae34761ccec081331cbebf6b5893c9af9f52873213ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca0b1c79f84e5bc71dbeae34761ccec081331cbebf6b5893c9af9f52873213ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "084c243c555e42c69e5ff737a23df39503f1e966163383d9372686e4d8e4f4e0"
    sha256 cellar: :any_skip_relocation, ventura:        "084c243c555e42c69e5ff737a23df39503f1e966163383d9372686e4d8e4f4e0"
    sha256 cellar: :any_skip_relocation, monterey:       "084c243c555e42c69e5ff737a23df39503f1e966163383d9372686e4d8e4f4e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca0b1c79f84e5bc71dbeae34761ccec081331cbebf6b5893c9af9f52873213ab"
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
