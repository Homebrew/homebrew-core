class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.5.3/phpstan.phar"
  sha256 "b485735f13b21d5cf6004d0f8d076443eb9ebdd4aab23051219416543c33b8a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac00a08c532788f6ad016a2265606f3f9a1ce8ba9c40647444763e7ce98a204f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac00a08c532788f6ad016a2265606f3f9a1ce8ba9c40647444763e7ce98a204f"
    sha256 cellar: :any_skip_relocation, monterey:       "1b1a5d59f4ce552f160e41f2e265144db3fb0e1e8f148cbfded3236c597ad739"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b1a5d59f4ce552f160e41f2e265144db3fb0e1e8f148cbfded3236c597ad739"
    sha256 cellar: :any_skip_relocation, catalina:       "1b1a5d59f4ce552f160e41f2e265144db3fb0e1e8f148cbfded3236c597ad739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac00a08c532788f6ad016a2265606f3f9a1ce8ba9c40647444763e7ce98a204f"
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
