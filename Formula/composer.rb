class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.3.4/composer.phar"
  sha256 "1fc8fc5b43f081fe76fa85eb5a213412e55f54a60bae4880bc96521ae482d6c3"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2de6026ea8857e91048820312912e062c915d015a6cfc783dbabc4efb228f2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2de6026ea8857e91048820312912e062c915d015a6cfc783dbabc4efb228f2c"
    sha256 cellar: :any_skip_relocation, monterey:       "b37194b8cfb2bae80c1852add70afcfb8e39dfbd5bfacb8662868a62a5295092"
    sha256 cellar: :any_skip_relocation, big_sur:        "b37194b8cfb2bae80c1852add70afcfb8e39dfbd5bfacb8662868a62a5295092"
    sha256 cellar: :any_skip_relocation, catalina:       "b37194b8cfb2bae80c1852add70afcfb8e39dfbd5bfacb8662868a62a5295092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2de6026ea8857e91048820312912e062c915d015a6cfc783dbabc4efb228f2c"
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
