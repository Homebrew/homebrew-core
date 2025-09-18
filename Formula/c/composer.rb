class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.8.11/composer.phar"
  sha256 "257a969e9a9d27e0e45cfe954835c17a76033ba84a388e0f472db83eded65a8b"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a7e2df1c80b6016af4623d64528b855b25b68a816f03bdec0d6fcb4a8000e45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a7e2df1c80b6016af4623d64528b855b25b68a816f03bdec0d6fcb4a8000e45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a7e2df1c80b6016af4623d64528b855b25b68a816f03bdec0d6fcb4a8000e45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a7e2df1c80b6016af4623d64528b855b25b68a816f03bdec0d6fcb4a8000e45"
    sha256 cellar: :any_skip_relocation, sonoma:        "4621c984a7fa38dc1fe4eea82429b5f571763723150eea4518024a19c992a0ee"
    sha256 cellar: :any_skip_relocation, ventura:       "4621c984a7fa38dc1fe4eea82429b5f571763723150eea4518024a19c992a0ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4621c984a7fa38dc1fe4eea82429b5f571763723150eea4518024a19c992a0ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4621c984a7fa38dc1fe4eea82429b5f571763723150eea4518024a19c992a0ee"
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
