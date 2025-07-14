class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.8.10/composer.phar"
  sha256 "28dbb6bd8bef31479c7985b774c130a8bda37dbe63c35b56f6cb6bc377427573"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6061b0daadbde2d445f44a64690c6848da8b43b06cd0cdf1b47024c6fb13e8a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6061b0daadbde2d445f44a64690c6848da8b43b06cd0cdf1b47024c6fb13e8a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6061b0daadbde2d445f44a64690c6848da8b43b06cd0cdf1b47024c6fb13e8a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "defa5ff7eb2e246349abedc74b506c8b2390d8b999bb623816dabfda18f04d92"
    sha256 cellar: :any_skip_relocation, ventura:       "defa5ff7eb2e246349abedc74b506c8b2390d8b999bb623816dabfda18f04d92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55861441ff00eeb47738be59a246fe8e75615f788bb34b8723a104a8f2571d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55861441ff00eeb47738be59a246fe8e75615f788bb34b8723a104a8f2571d40"
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
