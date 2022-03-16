class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.2.9/composer.phar"
  sha256 "48f9fdc9ad93904fee96550b45ae03a51f69718502ee855da894b4ad71d2dfe0"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a9516e56293e464b22c329f70f5212f50763b1d1dab0d831b9aaa89ac59e94e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a9516e56293e464b22c329f70f5212f50763b1d1dab0d831b9aaa89ac59e94e"
    sha256 cellar: :any_skip_relocation, monterey:       "5f6972f625509ba417f389d5218ac07f3b7eafd4bdc3902d67858f4f7b8542d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f6972f625509ba417f389d5218ac07f3b7eafd4bdc3902d67858f4f7b8542d7"
    sha256 cellar: :any_skip_relocation, catalina:       "5f6972f625509ba417f389d5218ac07f3b7eafd4bdc3902d67858f4f7b8542d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a9516e56293e464b22c329f70f5212f50763b1d1dab0d831b9aaa89ac59e94e"
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
