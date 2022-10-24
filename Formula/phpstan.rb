class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.8.11/phpstan.phar"
  sha256 "46c3cd4756b705dc910d53ee0f688cae5f1a47e9ee465e92926fbcd5c139a2f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2d51c66427c494f0ce22c5b0d9f64d99c0edeb70403bd9cd623bc1646a96a6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2d51c66427c494f0ce22c5b0d9f64d99c0edeb70403bd9cd623bc1646a96a6b"
    sha256 cellar: :any_skip_relocation, monterey:       "5da532a9df098ae80f3235f2ca1eb25c6accde819a86c3ca6d7dd5d73591b825"
    sha256 cellar: :any_skip_relocation, big_sur:        "5da532a9df098ae80f3235f2ca1eb25c6accde819a86c3ca6d7dd5d73591b825"
    sha256 cellar: :any_skip_relocation, catalina:       "5da532a9df098ae80f3235f2ca1eb25c6accde819a86c3ca6d7dd5d73591b825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2d51c66427c494f0ce22c5b0d9f64d99c0edeb70403bd9cd623bc1646a96a6b"
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
