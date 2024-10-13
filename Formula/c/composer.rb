class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.8.1/composer.phar"
  sha256 "930b376fbd2147a623ea7b704eb9d3b8b0d6072992207aa0535aa21f6f05378e"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a23fa31483840bc0121c660ac1d0559e88575170cd4f846ec817bd19442d45b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a23fa31483840bc0121c660ac1d0559e88575170cd4f846ec817bd19442d45b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a23fa31483840bc0121c660ac1d0559e88575170cd4f846ec817bd19442d45b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "986ebc4bc4b27ed307bb738d4223f5c2fae741b45692b26ff526083c876d0425"
    sha256 cellar: :any_skip_relocation, ventura:       "986ebc4bc4b27ed307bb738d4223f5c2fae741b45692b26ff526083c876d0425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6cfed4a518a84ea523d9887c0664d3e93b893ea9e0c20e004fec350f0730bb3"
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

    system bin/"composer", "install"
    assert_match(/^HelloHomebrew$/, shell_output("php tests/test.php"))
  end
end
