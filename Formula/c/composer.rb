class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.9.5/composer.phar"
  sha256 "c86ce603fe836bf0861a38c93ac566c8f1e69ac44b2445d9b7a6a17ea2e9972a"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d4d080ee7c7a4668d4d1744bcb9db0f68297d1504fef0dbf3ebf6bc9f90ac9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d4d080ee7c7a4668d4d1744bcb9db0f68297d1504fef0dbf3ebf6bc9f90ac9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d4d080ee7c7a4668d4d1744bcb9db0f68297d1504fef0dbf3ebf6bc9f90ac9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa34806e3de45f4fc0f1d53168021264d97a70558708a21f8a588abe0f204d12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa34806e3de45f4fc0f1d53168021264d97a70558708a21f8a588abe0f204d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa34806e3de45f4fc0f1d53168021264d97a70558708a21f8a588abe0f204d12"
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
    (testpath/"composer.json").write <<~JSON
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
    JSON

    (testpath/"src/HelloWorld/Greetings.php").write <<~PHP
      <?php

      namespace HelloWorld;

      class Greetings {
        public static function sayHelloWorld() {
          return 'HelloHomebrew';
        }
      }
    PHP

    (testpath/"tests/test.php").write <<~PHP
      <?php

      // Autoload files using the Composer autoloader.
      require_once __DIR__ . '/../vendor/autoload.php';

      use HelloWorld\\Greetings;

      echo Greetings::sayHelloWorld();
    PHP

    system bin/"composer", "install"
    assert_match(/^HelloHomebrew$/, shell_output("php tests/test.php"))
  end
end
