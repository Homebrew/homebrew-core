class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.4.2/composer.phar"
  sha256 "8fe98a01050c92cc6812b8ead3bd5b6e0bcdc575ce7a93b242bde497a31d7732"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7ba868aa113551ca93506cea1dce2637138aa6e711e0e5674c4a587ed471020"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7ba868aa113551ca93506cea1dce2637138aa6e711e0e5674c4a587ed471020"
    sha256 cellar: :any_skip_relocation, monterey:       "369669ccb9415ee687987b9f39c1fd8d451b9809d9c58b07a2a823562e3e9951"
    sha256 cellar: :any_skip_relocation, big_sur:        "369669ccb9415ee687987b9f39c1fd8d451b9809d9c58b07a2a823562e3e9951"
    sha256 cellar: :any_skip_relocation, catalina:       "369669ccb9415ee687987b9f39c1fd8d451b9809d9c58b07a2a823562e3e9951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7ba868aa113551ca93506cea1dce2637138aa6e711e0e5674c4a587ed471020"
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
