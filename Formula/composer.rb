class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.3.7/composer.phar"
  sha256 "3f2d46787d51070f922bf991aa08324566f726f186076c2a5e4e8b01a8ea3fd0"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "205493f3e4d993f6103442529e0cd8a7f1defda8ad846b785557b3677f8705a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "205493f3e4d993f6103442529e0cd8a7f1defda8ad846b785557b3677f8705a4"
    sha256 cellar: :any_skip_relocation, monterey:       "33b9f635b16136115a3c3176dae09fe9ce4b51b086aaa3d03c8d219595f58354"
    sha256 cellar: :any_skip_relocation, big_sur:        "33b9f635b16136115a3c3176dae09fe9ce4b51b086aaa3d03c8d219595f58354"
    sha256 cellar: :any_skip_relocation, catalina:       "33b9f635b16136115a3c3176dae09fe9ce4b51b086aaa3d03c8d219595f58354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "205493f3e4d993f6103442529e0cd8a7f1defda8ad846b785557b3677f8705a4"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
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
