class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.29/phpstan.phar"
  sha256 "7741c99267f55af7e46b0f2d8dfbb0e4139c8756526d6dba08c4eea1faf99dc0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6075466e2e257647372a155187d76feb457da4e7ba187a874c4ea539b0a9ae1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6075466e2e257647372a155187d76feb457da4e7ba187a874c4ea539b0a9ae1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6075466e2e257647372a155187d76feb457da4e7ba187a874c4ea539b0a9ae1f"
    sha256 cellar: :any_skip_relocation, ventura:        "414ed9ad7e0e13a63b665cec190ac70c3d01262649052339dc72ef1b71bd0631"
    sha256 cellar: :any_skip_relocation, monterey:       "414ed9ad7e0e13a63b665cec190ac70c3d01262649052339dc72ef1b71bd0631"
    sha256 cellar: :any_skip_relocation, big_sur:        "414ed9ad7e0e13a63b665cec190ac70c3d01262649052339dc72ef1b71bd0631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6075466e2e257647372a155187d76feb457da4e7ba187a874c4ea539b0a9ae1f"
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
