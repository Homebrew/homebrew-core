class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.29/phpstan.phar"
  sha256 "339e605ebcfde856cc87650d269087aff3ec61a693aed266d2698dc3c45cc4c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ac96a2f55b62bbc1ac3da02ed1a1a026a045f4a2a18baaa524f73fc517d1299"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ac96a2f55b62bbc1ac3da02ed1a1a026a045f4a2a18baaa524f73fc517d1299"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ac96a2f55b62bbc1ac3da02ed1a1a026a045f4a2a18baaa524f73fc517d1299"
    sha256 cellar: :any_skip_relocation, sonoma:        "e18fb3c63d6d68f1b20a4fc2fc8488b77d747930ad38b31ff134cd7c7156341f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e18fb3c63d6d68f1b20a4fc2fc8488b77d747930ad38b31ff134cd7c7156341f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e18fb3c63d6d68f1b20a4fc2fc8488b77d747930ad38b31ff134cd7c7156341f"
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
    (testpath/"src/autoload.php").write <<~PHP
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
    PHP

    (testpath/"src/Email.php").write <<~PHP
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
    PHP
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end
