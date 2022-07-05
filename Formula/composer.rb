class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.3.9/composer.phar"
  sha256 "0ec0cd63115cad28307e4b796350712e3cb77db992399aeb4a18a9c0680d7de2"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2cee3793647996652fc987072cb2817445101ec6dfe0690aa05723529e11afd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2cee3793647996652fc987072cb2817445101ec6dfe0690aa05723529e11afd"
    sha256 cellar: :any_skip_relocation, monterey:       "3e110c935f9cb06bdd3bbae4a7cfc8f0402a4cf3bf8c32727e0d78e843760489"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e110c935f9cb06bdd3bbae4a7cfc8f0402a4cf3bf8c32727e0d78e843760489"
    sha256 cellar: :any_skip_relocation, catalina:       "3e110c935f9cb06bdd3bbae4a7cfc8f0402a4cf3bf8c32727e0d78e843760489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2cee3793647996652fc987072cb2817445101ec6dfe0690aa05723529e11afd"
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
