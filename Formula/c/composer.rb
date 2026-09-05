class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.10.3/composer.phar"
  sha256 "7a2d379d5b8ffdaa028580ef26494c36d2feef4b178d3dd1473a4dbc5e17c8d6"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8855724526da9db4caa9a2c99f9964676bdc9462098adb8ad1388b051a5ad7b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8855724526da9db4caa9a2c99f9964676bdc9462098adb8ad1388b051a5ad7b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8855724526da9db4caa9a2c99f9964676bdc9462098adb8ad1388b051a5ad7b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4c0a7ebb8e215eadc9489779cabba06ca58e1bb6b4e168c2e2b35b9af32aab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4c0a7ebb8e215eadc9489779cabba06ca58e1bb6b4e168c2e2b35b9af32aab6"
  end

  depends_on "php"

  def install
    # Keep the signed Phar non-executable so bottle relocation does not modify it.
    libexec.install "composer.phar"

    (bin/"composer").write <<~PHP
      #!#{formula_opt_bin("php")}/php
      <?php require '#{libexec}/composer.phar';
    PHP
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
