class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.9.4/phpstan.phar"
  sha256 "03e17f6682fa74b631e0c58dd1e597b509e65893d806a11c4a0638035a11de6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d5dc73dcc8d71e7abfb90318826313f1ea4369e0868c13deb6fa162c894b0b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d5dc73dcc8d71e7abfb90318826313f1ea4369e0868c13deb6fa162c894b0b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d5dc73dcc8d71e7abfb90318826313f1ea4369e0868c13deb6fa162c894b0b2"
    sha256 cellar: :any_skip_relocation, ventura:        "27bb3017ae9a0bd584bfa9f83a804a85808ce53f72187bb4c3e0bd28b90d6443"
    sha256 cellar: :any_skip_relocation, monterey:       "27bb3017ae9a0bd584bfa9f83a804a85808ce53f72187bb4c3e0bd28b90d6443"
    sha256 cellar: :any_skip_relocation, big_sur:        "27bb3017ae9a0bd584bfa9f83a804a85808ce53f72187bb4c3e0bd28b90d6443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d5dc73dcc8d71e7abfb90318826313f1ea4369e0868c13deb6fa162c894b0b2"
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
