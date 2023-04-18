class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.5.5/composer.phar"
  sha256 "566a6d1cf4be1cc3ac882d2a2a13817ffae54e60f5aa7c9137434810a5809ffc"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8f92a1131adfaea8335e760221d36ac78b62b3879d14937dbe9d79861f30dc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8f92a1131adfaea8335e760221d36ac78b62b3879d14937dbe9d79861f30dc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8f92a1131adfaea8335e760221d36ac78b62b3879d14937dbe9d79861f30dc2"
    sha256 cellar: :any_skip_relocation, ventura:        "435130b44dba518eabcc2fc101ec9d5d41165e7ce7df01241ced8767742c5df9"
    sha256 cellar: :any_skip_relocation, monterey:       "435130b44dba518eabcc2fc101ec9d5d41165e7ce7df01241ced8767742c5df9"
    sha256 cellar: :any_skip_relocation, big_sur:        "435130b44dba518eabcc2fc101ec9d5d41165e7ce7df01241ced8767742c5df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8f92a1131adfaea8335e760221d36ac78b62b3879d14937dbe9d79861f30dc2"
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
