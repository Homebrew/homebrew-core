class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.9.11/phpstan.phar"
  sha256 "2f1f736702d43cea3341a376d0ee7a62174928b00913d2c86c9ca50658a6892b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c66bed5665eb9d3c87ed37970586e0d507b3e8064e0b7ef094513676702a999"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c66bed5665eb9d3c87ed37970586e0d507b3e8064e0b7ef094513676702a999"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c66bed5665eb9d3c87ed37970586e0d507b3e8064e0b7ef094513676702a999"
    sha256 cellar: :any_skip_relocation, ventura:        "4dd40c9d90d7bc5970284f773455eebb1da7dce6851ca58605dfec603e367344"
    sha256 cellar: :any_skip_relocation, monterey:       "4dd40c9d90d7bc5970284f773455eebb1da7dce6851ca58605dfec603e367344"
    sha256 cellar: :any_skip_relocation, big_sur:        "4dd40c9d90d7bc5970284f773455eebb1da7dce6851ca58605dfec603e367344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c66bed5665eb9d3c87ed37970586e0d507b3e8064e0b7ef094513676702a999"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
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
