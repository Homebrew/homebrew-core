class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.8.2/phpstan.phar"
  sha256 "3676c437d7613d406d80488a8f9981b56f519d313d8e6c7f66a45daa6bb22288"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fd89365ffccb5e6232f6b986ddd2a2b25b40c2d9bfdf4b99af323ad490c003b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fd89365ffccb5e6232f6b986ddd2a2b25b40c2d9bfdf4b99af323ad490c003b"
    sha256 cellar: :any_skip_relocation, monterey:       "f9d66f862e450623a891dd8bfeb7c6279f8904d778b39e7f13e5242f6e711df5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9d66f862e450623a891dd8bfeb7c6279f8904d778b39e7f13e5242f6e711df5"
    sha256 cellar: :any_skip_relocation, catalina:       "f9d66f862e450623a891dd8bfeb7c6279f8904d778b39e7f13e5242f6e711df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fd89365ffccb5e6232f6b986ddd2a2b25b40c2d9bfdf4b99af323ad490c003b"
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
