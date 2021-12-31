class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.2.3/composer.phar"
  sha256 "721cc27f81c6485fff70e6f56b9f2aadae770a1f8974a384c34e35987a230d8c"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09a6c6a06c5e94380569e7d9aab585e3ca69c513e9bb85a5f9ea487a8d7e90dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09a6c6a06c5e94380569e7d9aab585e3ca69c513e9bb85a5f9ea487a8d7e90dd"
    sha256 cellar: :any_skip_relocation, monterey:       "340c2cd69a8a1d82f1896ac44db57180899e84d97c943532a0ad4357f8504b8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "340c2cd69a8a1d82f1896ac44db57180899e84d97c943532a0ad4357f8504b8d"
    sha256 cellar: :any_skip_relocation, catalina:       "340c2cd69a8a1d82f1896ac44db57180899e84d97c943532a0ad4357f8504b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09a6c6a06c5e94380569e7d9aab585e3ca69c513e9bb85a5f9ea487a8d7e90dd"
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
