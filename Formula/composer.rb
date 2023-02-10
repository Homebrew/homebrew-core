class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.5.3/composer.phar"
  sha256 "2e1061821951c6a5ece033a025d06296d4a1d056fee2f4bebd35815cf4b1b0f9"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2eb3739f157bf8b74c4398c59b6d1a8aca58ff9cdda07ab2dda41cd9aae44084"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2eb3739f157bf8b74c4398c59b6d1a8aca58ff9cdda07ab2dda41cd9aae44084"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2eb3739f157bf8b74c4398c59b6d1a8aca58ff9cdda07ab2dda41cd9aae44084"
    sha256 cellar: :any_skip_relocation, ventura:        "f2c341c2e2206b37cc44102bc06f95eb5e5e3f89abd5ab8e347ddc47b24d7150"
    sha256 cellar: :any_skip_relocation, monterey:       "f2c341c2e2206b37cc44102bc06f95eb5e5e3f89abd5ab8e347ddc47b24d7150"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2c341c2e2206b37cc44102bc06f95eb5e5e3f89abd5ab8e347ddc47b24d7150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eb3739f157bf8b74c4398c59b6d1a8aca58ff9cdda07ab2dda41cd9aae44084"
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
