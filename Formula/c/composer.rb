class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.8.9/composer.phar"
  sha256 "8e8829ec2b97fcb05158236984bc252bef902e7b8ff65555a1eeda4ec13fb82b"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a05a5caf378a6feffbe8eb20a6df237f2fbdcd4ad95c330523721cba76c5ae24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a05a5caf378a6feffbe8eb20a6df237f2fbdcd4ad95c330523721cba76c5ae24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a05a5caf378a6feffbe8eb20a6df237f2fbdcd4ad95c330523721cba76c5ae24"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f0caa6188458c601c106506cc548b99c711f6cd267cbe757ea80cc0307aac40"
    sha256 cellar: :any_skip_relocation, ventura:       "1f0caa6188458c601c106506cc548b99c711f6cd267cbe757ea80cc0307aac40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00b726600dae89baf262d48d9919975579522b14e5a163506aedba18a74d3eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00b726600dae89baf262d48d9919975579522b14e5a163506aedba18a74d3eab"
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
