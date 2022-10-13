class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.8.9/phpstan.phar"
  sha256 "768a4dcb07922095830fafb11e075894e382925d256787d2ec150a886c0a62c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7ad9e2df6d6fa20d4c303671c0024ddd3dfd8c640cd06f338629b40756d93e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7ad9e2df6d6fa20d4c303671c0024ddd3dfd8c640cd06f338629b40756d93e7"
    sha256 cellar: :any_skip_relocation, monterey:       "5504925395a46d2285c4d28f1fff928094e5d61bcdb6297db9637e3ca14fc77f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5504925395a46d2285c4d28f1fff928094e5d61bcdb6297db9637e3ca14fc77f"
    sha256 cellar: :any_skip_relocation, catalina:       "5504925395a46d2285c4d28f1fff928094e5d61bcdb6297db9637e3ca14fc77f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7ad9e2df6d6fa20d4c303671c0024ddd3dfd8c640cd06f338629b40756d93e7"
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
