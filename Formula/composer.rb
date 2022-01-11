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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76da9bc139f88ceab4ef6bba9bf6b1e9dd7c9caf1c11f4c8ffe3cb2e8573ed7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76da9bc139f88ceab4ef6bba9bf6b1e9dd7c9caf1c11f4c8ffe3cb2e8573ed7e"
    sha256 cellar: :any_skip_relocation, monterey:       "206222d32c7c03e1385afd227e2d83f749920c5ecd91f2b26ee8029bae2d57c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "206222d32c7c03e1385afd227e2d83f749920c5ecd91f2b26ee8029bae2d57c2"
    sha256 cellar: :any_skip_relocation, catalina:       "206222d32c7c03e1385afd227e2d83f749920c5ecd91f2b26ee8029bae2d57c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76da9bc139f88ceab4ef6bba9bf6b1e9dd7c9caf1c11f4c8ffe3cb2e8573ed7e"
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
