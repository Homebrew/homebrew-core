class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.1.11/composer.phar"
  sha256 "fdb587131f8a11fcd475c9949ca340cc58a4b50cce6833caa8118b759a4ad1a3"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71187cda00a0a72bc2fe2da657f98152d834f957909f8f7db23236ba888eb101"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71187cda00a0a72bc2fe2da657f98152d834f957909f8f7db23236ba888eb101"
    sha256 cellar: :any_skip_relocation, monterey:       "4dfab6bfb3f4ba36582199cbff36f3cb41bf7630ef21e872a023144aa8c078db"
    sha256 cellar: :any_skip_relocation, big_sur:        "4dfab6bfb3f4ba36582199cbff36f3cb41bf7630ef21e872a023144aa8c078db"
    sha256 cellar: :any_skip_relocation, catalina:       "4dfab6bfb3f4ba36582199cbff36f3cb41bf7630ef21e872a023144aa8c078db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71187cda00a0a72bc2fe2da657f98152d834f957909f8f7db23236ba888eb101"
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
