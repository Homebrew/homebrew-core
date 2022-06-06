class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.3.7/composer.phar"
  sha256 "3f2d46787d51070f922bf991aa08324566f726f186076c2a5e4e8b01a8ea3fd0"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a54ad31da517d0444bee7e0b67784e5246ee0fc33b78cc1b2d3603796545ba8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a54ad31da517d0444bee7e0b67784e5246ee0fc33b78cc1b2d3603796545ba8a"
    sha256 cellar: :any_skip_relocation, monterey:       "a46dfb9a39b3dad431eb6ed7c5c3ab70574ed2a7ea73c3048819cc3754175f4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a46dfb9a39b3dad431eb6ed7c5c3ab70574ed2a7ea73c3048819cc3754175f4a"
    sha256 cellar: :any_skip_relocation, catalina:       "a46dfb9a39b3dad431eb6ed7c5c3ab70574ed2a7ea73c3048819cc3754175f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a54ad31da517d0444bee7e0b67784e5246ee0fc33b78cc1b2d3603796545ba8a"
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
