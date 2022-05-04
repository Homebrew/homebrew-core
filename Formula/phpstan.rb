class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.6.5/phpstan.phar"
  sha256 "f4c8bf4ea80bb35b0434e3a4a56704590a7d498b08e039003dad95a9be3b3231"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f1d410a0e15275fd64098ba20aafedb8b8c1ac0a1ddfb5953de715f85369b68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f1d410a0e15275fd64098ba20aafedb8b8c1ac0a1ddfb5953de715f85369b68"
    sha256 cellar: :any_skip_relocation, monterey:       "2cddc02cc6f70b6cd3579d490a1589284de18c5c4d60073b8c45bad9f85fbdb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cddc02cc6f70b6cd3579d490a1589284de18c5c4d60073b8c45bad9f85fbdb2"
    sha256 cellar: :any_skip_relocation, catalina:       "2cddc02cc6f70b6cd3579d490a1589284de18c5c4d60073b8c45bad9f85fbdb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f1d410a0e15275fd64098ba20aafedb8b8c1ac0a1ddfb5953de715f85369b68"
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
