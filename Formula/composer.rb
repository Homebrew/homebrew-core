class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.1.9/composer.phar"
  sha256 "4d00b70e146c17d663ad2f9a21ebb4c9d52b021b1ac15f648b4d371c04d648ba"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "742ce90ec5d5cb121c04930ebe928bf694bc75a87cfa37a56f0ca10a144fa821"
    sha256 cellar: :any_skip_relocation, big_sur:       "1ba9bd63928798e06c4b2d33ba6089b5ed074a0aa4a7b30ca22c6965503fcdbc"
    sha256 cellar: :any_skip_relocation, catalina:      "1ba9bd63928798e06c4b2d33ba6089b5ed074a0aa4a7b30ca22c6965503fcdbc"
    sha256 cellar: :any_skip_relocation, mojave:        "1ba9bd63928798e06c4b2d33ba6089b5ed074a0aa4a7b30ca22c6965503fcdbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "742ce90ec5d5cb121c04930ebe928bf694bc75a87cfa37a56f0ca10a144fa821"
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
