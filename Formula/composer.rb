class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.2.7/composer.phar"
  sha256 "10040ded663541990eef8ce1f6fa44cb3b4a47e145efb8e9e59907a15068033d"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81fa7903a8c2204ed21b0cf8e89118c7518d4f0cded9fffe7df8e6098debceb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81fa7903a8c2204ed21b0cf8e89118c7518d4f0cded9fffe7df8e6098debceb4"
    sha256 cellar: :any_skip_relocation, monterey:       "ba48252c4f7399c0398aee73b18ca627527f782b1575937091c8fcb3f91223b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba48252c4f7399c0398aee73b18ca627527f782b1575937091c8fcb3f91223b7"
    sha256 cellar: :any_skip_relocation, catalina:       "ba48252c4f7399c0398aee73b18ca627527f782b1575937091c8fcb3f91223b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81fa7903a8c2204ed21b0cf8e89118c7518d4f0cded9fffe7df8e6098debceb4"
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
