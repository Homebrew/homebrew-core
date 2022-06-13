class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.7.13/phpstan.phar"
  sha256 "97e1641e23bb6a51e06737ae32f3bc61069e29fab91614f8fc838f25bf1ff49e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d98b802758215c3542d32a889ac4503cfc26179830b880b56774bea32bee0199"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d98b802758215c3542d32a889ac4503cfc26179830b880b56774bea32bee0199"
    sha256 cellar: :any_skip_relocation, monterey:       "768df5f34bbb5fa348789daa70d361869d08bfbc2c21b47486b247ca89ea5156"
    sha256 cellar: :any_skip_relocation, big_sur:        "768df5f34bbb5fa348789daa70d361869d08bfbc2c21b47486b247ca89ea5156"
    sha256 cellar: :any_skip_relocation, catalina:       "768df5f34bbb5fa348789daa70d361869d08bfbc2c21b47486b247ca89ea5156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d98b802758215c3542d32a889ac4503cfc26179830b880b56774bea32bee0199"
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
