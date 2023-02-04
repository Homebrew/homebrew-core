class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.5.2/composer.phar"
  sha256 "0844c3dd85bbfa039d33fbda58ae65a38a9f615fcba76948aed75bf94d7606ca"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60d0bda416fefeeaf75369713d730bef09954b84f40b112734c8736b2cb0d82b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60d0bda416fefeeaf75369713d730bef09954b84f40b112734c8736b2cb0d82b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60d0bda416fefeeaf75369713d730bef09954b84f40b112734c8736b2cb0d82b"
    sha256 cellar: :any_skip_relocation, ventura:        "10e8090290f17cbc009ff3baa47baf3e2149409ee74cf2e8d306742a5789ff61"
    sha256 cellar: :any_skip_relocation, monterey:       "10e8090290f17cbc009ff3baa47baf3e2149409ee74cf2e8d306742a5789ff61"
    sha256 cellar: :any_skip_relocation, big_sur:        "10e8090290f17cbc009ff3baa47baf3e2149409ee74cf2e8d306742a5789ff61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60d0bda416fefeeaf75369713d730bef09954b84f40b112734c8736b2cb0d82b"
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
