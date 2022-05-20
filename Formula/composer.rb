class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.3.5/composer.phar"
  sha256 "3b3b5a899c06a46aec280727bdf50aad14334f6bc40436ea76b07b650870d8f4"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0d482df0a891ca88403b06183fd62084196d7360990c64d97ca0cb0c479bcbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0d482df0a891ca88403b06183fd62084196d7360990c64d97ca0cb0c479bcbb"
    sha256 cellar: :any_skip_relocation, monterey:       "0eec2b01f0467d56df93fcfef0e9751a951c4bdcd8598f6a688fc95d68588d8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0eec2b01f0467d56df93fcfef0e9751a951c4bdcd8598f6a688fc95d68588d8e"
    sha256 cellar: :any_skip_relocation, catalina:       "0eec2b01f0467d56df93fcfef0e9751a951c4bdcd8598f6a688fc95d68588d8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0d482df0a891ca88403b06183fd62084196d7360990c64d97ca0cb0c479bcbb"
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
