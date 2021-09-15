class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.1.7/composer.phar"
  sha256 "2936587e1babafa50d15eacf9fe775e825ed2e1f051c61acd3fa4f6af7720e94"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "222d26e07d276a0d17d264e12dbe657b959d8fb006a4365640f9149c66055160"
    sha256 cellar: :any_skip_relocation, big_sur:       "9b514659ab7804211b191eaf4f6d5ca274cc77711073c8b4eab305c0955a8fd9"
    sha256 cellar: :any_skip_relocation, catalina:      "9b514659ab7804211b191eaf4f6d5ca274cc77711073c8b4eab305c0955a8fd9"
    sha256 cellar: :any_skip_relocation, mojave:        "9b514659ab7804211b191eaf4f6d5ca274cc77711073c8b4eab305c0955a8fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "222d26e07d276a0d17d264e12dbe657b959d8fb006a4365640f9149c66055160"
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
