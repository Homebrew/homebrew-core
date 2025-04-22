class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.8.8/composer.phar"
  sha256 "957263e284b9f7a13d7f475dc65f3614d151b0c4dcc7e8761f7e7f749447fb68"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e528b9bc47d85e801cee93236367f5abf7a52001864ca8492a52a75479f2414"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e528b9bc47d85e801cee93236367f5abf7a52001864ca8492a52a75479f2414"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e528b9bc47d85e801cee93236367f5abf7a52001864ca8492a52a75479f2414"
    sha256 cellar: :any_skip_relocation, sonoma:        "c07890dce3f5995d1c14f30d8b20d91e60628aab80bdd9f29551ec63eff295d7"
    sha256 cellar: :any_skip_relocation, ventura:       "c07890dce3f5995d1c14f30d8b20d91e60628aab80bdd9f29551ec63eff295d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54e14a3f2ada5b903018d3c4795a346277aed4c0487c8643c1f8ea3dae0bdff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54e14a3f2ada5b903018d3c4795a346277aed4c0487c8643c1f8ea3dae0bdff1"
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
