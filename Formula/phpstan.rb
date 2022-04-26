class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.6.0/phpstan.phar"
  sha256 "3c94658af6d8ac43a9b5d639b8bfb304612aa7d6f1ff421533bb0ae742f93f6b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "421ead6abdedf8621ea47e7c28740ab4976856c7503b50398aa0d15f04200d4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "421ead6abdedf8621ea47e7c28740ab4976856c7503b50398aa0d15f04200d4e"
    sha256 cellar: :any_skip_relocation, monterey:       "ea95ecd82ba4b415940cdec6368afd1f346900329bfd5455a133ca383e9fcf36"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea95ecd82ba4b415940cdec6368afd1f346900329bfd5455a133ca383e9fcf36"
    sha256 cellar: :any_skip_relocation, catalina:       "ea95ecd82ba4b415940cdec6368afd1f346900329bfd5455a133ca383e9fcf36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "421ead6abdedf8621ea47e7c28740ab4976856c7503b50398aa0d15f04200d4e"
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
