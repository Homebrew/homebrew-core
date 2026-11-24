class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.11.3/composer.phar"
  sha256 "04f8b003da4e3a2459056591fbfebd02b4dc3e5adeb158616b90cf55a65113ec"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    manifest_sha256 "29c91e705e2d1e08a6dac9990c11f8ef6ce92d5b3aad3cafe2393fbca9aa7760"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6c39fe505d8cd811977c12ddf0ab9c973a3a54d8e1330950b4b29069eeac4b8e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c39fe505d8cd811977c12ddf0ab9c973a3a54d8e1330950b4b29069eeac4b8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c39fe505d8cd811977c12ddf0ab9c973a3a54d8e1330950b4b29069eeac4b8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "15bb890c4482eb1a4339ef9b0b8fea0c03ecd807be3f9307584652578de2da9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "15bb890c4482eb1a4339ef9b0b8fea0c03ecd807be3f9307584652578de2da9b"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces the prefix with a non-default value
  on_macos do
    pour_bottle? only_if: :default_prefix
  end

  allow_network_access! :test

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
