class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.5.7/composer.phar"
  sha256 "9256c4c1c803b9d0cb7a66a1ab6c737e48c43cc6df7b8ec9ec2497a724bf44de"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4eea7c60c1497e501f729787be47ac079edca56055329638ef5c621b64eaffe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4eea7c60c1497e501f729787be47ac079edca56055329638ef5c621b64eaffe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4eea7c60c1497e501f729787be47ac079edca56055329638ef5c621b64eaffe"
    sha256 cellar: :any_skip_relocation, ventura:        "e324d5a23fe8b99a1130c51ef779b731051569afe37f7c16e7579cab81eb5d1f"
    sha256 cellar: :any_skip_relocation, monterey:       "e324d5a23fe8b99a1130c51ef779b731051569afe37f7c16e7579cab81eb5d1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e324d5a23fe8b99a1130c51ef779b731051569afe37f7c16e7579cab81eb5d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4eea7c60c1497e501f729787be47ac079edca56055329638ef5c621b64eaffe"
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
