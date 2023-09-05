class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.6.2/composer.phar"
  sha256 "88c84d4a53fcf1c27d6762e1d5d6b70d57c6dc9d2e2314fd09dbf86bf61e1aef"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6376100cdd288709ea1123254118d5b1c412bebddc004b54faaa66b79abfe67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6376100cdd288709ea1123254118d5b1c412bebddc004b54faaa66b79abfe67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6376100cdd288709ea1123254118d5b1c412bebddc004b54faaa66b79abfe67"
    sha256 cellar: :any_skip_relocation, ventura:        "f453d1360a934c97dc6c0314562b6d9f25baf6b79aa2df1febd91cc3cdd20c41"
    sha256 cellar: :any_skip_relocation, monterey:       "f453d1360a934c97dc6c0314562b6d9f25baf6b79aa2df1febd91cc3cdd20c41"
    sha256 cellar: :any_skip_relocation, big_sur:        "f453d1360a934c97dc6c0314562b6d9f25baf6b79aa2df1febd91cc3cdd20c41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6376100cdd288709ea1123254118d5b1c412bebddc004b54faaa66b79abfe67"
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
