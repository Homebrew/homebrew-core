class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.2.4/composer.phar"
  sha256 "ba04e246960d193237d5ed6542bd78456898e7787fafb586f500c6807af7458d"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82a40cc9253c34120ee8a8906055d4d0a54bc8a8885e486370b133a86de9a9f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82a40cc9253c34120ee8a8906055d4d0a54bc8a8885e486370b133a86de9a9f1"
    sha256 cellar: :any_skip_relocation, monterey:       "6e38ccbee2ababa044be4b3b2fb58fc371239aaf5ee1defd258c896d61c9a048"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e38ccbee2ababa044be4b3b2fb58fc371239aaf5ee1defd258c896d61c9a048"
    sha256 cellar: :any_skip_relocation, catalina:       "6e38ccbee2ababa044be4b3b2fb58fc371239aaf5ee1defd258c896d61c9a048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82a40cc9253c34120ee8a8906055d4d0a54bc8a8885e486370b133a86de9a9f1"
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
