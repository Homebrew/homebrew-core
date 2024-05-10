class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.7.6/composer.phar"
  sha256 "29dc9a19ef33535db061b31180b2a833a7cf8d2cf4145b33a2f83504877bba08"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fa0470888f4d6aea93667ac7b4f17f1c35b9c0c4b62c650385ff56078bc00d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fa0470888f4d6aea93667ac7b4f17f1c35b9c0c4b62c650385ff56078bc00d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fa0470888f4d6aea93667ac7b4f17f1c35b9c0c4b62c650385ff56078bc00d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "64201d4c8c885e763ba1d7f691ab4b7f1de80c0065f152a7e04cee5d3d939269"
    sha256 cellar: :any_skip_relocation, ventura:        "64201d4c8c885e763ba1d7f691ab4b7f1de80c0065f152a7e04cee5d3d939269"
    sha256 cellar: :any_skip_relocation, monterey:       "64201d4c8c885e763ba1d7f691ab4b7f1de80c0065f152a7e04cee5d3d939269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "703b7d65484014751b2f0b38e13c106db991483fe0ba47fdcd7ef2edc2076587"
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
