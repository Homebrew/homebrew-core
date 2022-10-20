class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.4.3/composer.phar"
  sha256 "26d72f2790502bc9b22209e1cec1e0e43d33b368606ad227d327cccb388b609a"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0728eceedfae4d68b631f8ca7e8da151f9ab5b61a0d30f869d62f96b110b7f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0728eceedfae4d68b631f8ca7e8da151f9ab5b61a0d30f869d62f96b110b7f8"
    sha256 cellar: :any_skip_relocation, monterey:       "592ef8d2fe4af1f85735d873d0357cab5c4bddc80e8bce1ca6fd02de88edc97f"
    sha256 cellar: :any_skip_relocation, big_sur:        "592ef8d2fe4af1f85735d873d0357cab5c4bddc80e8bce1ca6fd02de88edc97f"
    sha256 cellar: :any_skip_relocation, catalina:       "592ef8d2fe4af1f85735d873d0357cab5c4bddc80e8bce1ca6fd02de88edc97f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0728eceedfae4d68b631f8ca7e8da151f9ab5b61a0d30f869d62f96b110b7f8"
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
