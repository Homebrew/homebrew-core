class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.28/phpstan.phar"
  sha256 "9126f2ebf5db597eb2b52de5103f1357118fe16a980633c06e902ae353db9b6d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76269a69b98ef16e5f4c505c389b3aa833511644039b98f79c8cafe479b07256"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76269a69b98ef16e5f4c505c389b3aa833511644039b98f79c8cafe479b07256"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76269a69b98ef16e5f4c505c389b3aa833511644039b98f79c8cafe479b07256"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a06be6377f3ee0eb9f51d22af28233520d50d8fffc8a8d577eb3e53a63fadfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a06be6377f3ee0eb9f51d22af28233520d50d8fffc8a8d577eb3e53a63fadfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a06be6377f3ee0eb9f51d22af28233520d50d8fffc8a8d577eb3e53a63fadfd"
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
