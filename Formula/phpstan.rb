class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.1.1/phpstan.phar"
  sha256 "4dc7daf7c24f7a2165f4ca349f211c47e81030c19a208400d3d26faae1cffd1a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec39f6a62931684c186d9918a85879f2678f266babd61ee34bba26169e8647a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec39f6a62931684c186d9918a85879f2678f266babd61ee34bba26169e8647a9"
    sha256 cellar: :any_skip_relocation, monterey:       "bbdb81aca79e147ece91a4b72bf7d8f5fc5604065a946438a3b20f5bbcc3ac08"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbdb81aca79e147ece91a4b72bf7d8f5fc5604065a946438a3b20f5bbcc3ac08"
    sha256 cellar: :any_skip_relocation, catalina:       "bbdb81aca79e147ece91a4b72bf7d8f5fc5604065a946438a3b20f5bbcc3ac08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec39f6a62931684c186d9918a85879f2678f266babd61ee34bba26169e8647a9"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
  end

  def install
    bin.install "phpstan.phar" => "phpstan"
  end

  test do
    (testpath/"src/autoload.php").write <<~EOS
      <?php
      spl_autoload_register(
          function($class) {
              static $classes = null;
              if ($classes === null) {
                  $classes = array(
                      'email' => '/Email.php'
                  );
              }
              $cn = strtolower($class);
              if (isset($classes[$cn])) {
                  require __DIR__ . $classes[$cn];
              }
          },
          true,
          false
      );
    EOS

    (testpath/"src/Email.php").write <<~EOS
      <?php
        declare(strict_types=1);

        final class Email
        {
            private string $email;

            private function __construct(string $email)
            {
                $this->ensureIsValidEmail($email);

                $this->email = $email;
            }

            public static function fromString(string $email): self
            {
                return new self($email);
            }

            public function __toString(): string
            {
                return $this->email;
            }

            private function ensureIsValidEmail(string $email): void
            {
                if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                    throw new InvalidArgumentException(
                        sprintf(
                            '"%s" is not a valid email address',
                            $email
                        )
                    );
                }
            }
        }
    EOS
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end
