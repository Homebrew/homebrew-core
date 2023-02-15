class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.5.4/composer.phar"
  sha256 "91ce6cbf9463eae86ae9d5c21d42faa601a519f3fbb2b623a55ee24678079bd3"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5191e398e6c1925c8b20fbacf3d66cf1c92fd6edff7a3850b156e54247bf9caa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79f1b6d66926ad688ab39dea7cf2e6317920ca88e077e233f568dbb142035598"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ac8704fb653a2d46b73f2844b7a774528cb3ca67c49804e5683dd0faef8d727"
    sha256 cellar: :any_skip_relocation, ventura:        "d8a0efe99a965d6f88a8c99816c6410a978f9004ca84cd8484a341d6eb73f57a"
    sha256 cellar: :any_skip_relocation, monterey:       "070471c956bf6414fb64be85eebc589024019565b62d668677905ef47986d85f"
    sha256 cellar: :any_skip_relocation, big_sur:        "51025e83a7870f2b4c1dff95acecab6698758a2b8ba526c2b86b6cef56bbf9fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6283a1533e1e7d7975da814051d52cfaa3113fc34ea0a4d4c98dab2a19c2e70"
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

    system "#{bin}/composer", "install"
    assert_match(/^HelloHomebrew$/, shell_output("php tests/test.php"))
  end
end
