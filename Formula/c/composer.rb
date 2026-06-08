class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.10.1/composer.phar"
  sha256 "345b9c6a98da5c30dcbd4b0d99fc8710bf0ae98a3898eea18f7b2ad9dec93f06"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "652e201e2463dae0c0cb559d77a7f66e88b2baa059f6fc94c021b927463c2013"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "652e201e2463dae0c0cb559d77a7f66e88b2baa059f6fc94c021b927463c2013"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "652e201e2463dae0c0cb559d77a7f66e88b2baa059f6fc94c021b927463c2013"
    sha256 cellar: :any_skip_relocation, sonoma:        "41f70f8f80aeee9ade2c8306a0ab1782aa2501ce5039f7c442bc9c06972906bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41f70f8f80aeee9ade2c8306a0ab1782aa2501ce5039f7c442bc9c06972906bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41f70f8f80aeee9ade2c8306a0ab1782aa2501ce5039f7c442bc9c06972906bf"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces the prefix with a non-default value
  on_macos do
    pour_bottle? only_if: :default_prefix
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
