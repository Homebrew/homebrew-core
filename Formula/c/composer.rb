class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.10.2/composer.phar"
  sha256 "5ee7125f8a30a34d246cefdc0bc85b8a783b28f2aec968994118512350d28027"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a75b416c4ba793c011519b09ce9464c6a1d207c478c4d58fc72b4c4516db468a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a75b416c4ba793c011519b09ce9464c6a1d207c478c4d58fc72b4c4516db468a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a75b416c4ba793c011519b09ce9464c6a1d207c478c4d58fc72b4c4516db468a"
    sha256 cellar: :any_skip_relocation, sonoma:        "233bb1bb84f102afa03e48e237ed0935dc20942d686abb8ad278590ab764931c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "233bb1bb84f102afa03e48e237ed0935dc20942d686abb8ad278590ab764931c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "233bb1bb84f102afa03e48e237ed0935dc20942d686abb8ad278590ab764931c"
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
