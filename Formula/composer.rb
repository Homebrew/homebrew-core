class Composer < Formula
  desc "Dependency Manager for PHP"
  homepage "https://getcomposer.org/"
  url "https://getcomposer.org/download/2.5.1/composer.phar"
  sha256 "f1b94fee11a5bd6a1aae5d77c8da269df27c705fcc806ebf4c8c2e6fa8645c20"
  license "MIT"

  livecheck do
    url "https://getcomposer.org/download/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/composer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "971afe84c080dc8f8a8d68791021e62cb80166a96f0ca3c6a14bbb4f54911c54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "971afe84c080dc8f8a8d68791021e62cb80166a96f0ca3c6a14bbb4f54911c54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "971afe84c080dc8f8a8d68791021e62cb80166a96f0ca3c6a14bbb4f54911c54"
    sha256 cellar: :any_skip_relocation, ventura:        "b606ca4b0c32723cfb369007d508b78ff9fb46c282326e6f407db6247fc029ed"
    sha256 cellar: :any_skip_relocation, monterey:       "b606ca4b0c32723cfb369007d508b78ff9fb46c282326e6f407db6247fc029ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "b606ca4b0c32723cfb369007d508b78ff9fb46c282326e6f407db6247fc029ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "971afe84c080dc8f8a8d68791021e62cb80166a96f0ca3c6a14bbb4f54911c54"
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
