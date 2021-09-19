class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.1.8/composer.phar"
  sha256 "77b8aca1b41174a67f27be066558f8a96f489916f4cded2bead3cab6a3f33590"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "084f24254cff5dacd15e29ab3ff23bbf041bef49751d0468100d6a95b509dd44"
    sha256 cellar: :any_skip_relocation, big_sur:       "36e0cd88a418f3213b792aa7fde7e1df762e7b243ca2bbb5df1c7b6b037ddcf6"
    sha256 cellar: :any_skip_relocation, catalina:      "36e0cd88a418f3213b792aa7fde7e1df762e7b243ca2bbb5df1c7b6b037ddcf6"
    sha256 cellar: :any_skip_relocation, mojave:        "36e0cd88a418f3213b792aa7fde7e1df762e7b243ca2bbb5df1c7b6b037ddcf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "084f24254cff5dacd15e29ab3ff23bbf041bef49751d0468100d6a95b509dd44"
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
