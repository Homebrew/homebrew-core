class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.17/phpstan.phar"
  sha256 "767edc1d6a596308c9bdd1fa7e42bf27c88ce3772b8e527cba87dc1c19bd1c3b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d23d686a2929ba4d04b8fc5f9150145aca497858bb7a1123bfc8214c38ca1a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d23d686a2929ba4d04b8fc5f9150145aca497858bb7a1123bfc8214c38ca1a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d23d686a2929ba4d04b8fc5f9150145aca497858bb7a1123bfc8214c38ca1a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8914d5c686db90bdea0bacd39c31a3f94497931ace3aa6cc62a1ab188ed9c5e"
    sha256 cellar: :any_skip_relocation, ventura:       "c8914d5c686db90bdea0bacd39c31a3f94497931ace3aa6cc62a1ab188ed9c5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b01493f02d7806b97f3507331b9fafaf5eca01345b310767079e5ce0246f8743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b01493f02d7806b97f3507331b9fafaf5eca01345b310767079e5ce0246f8743"
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
