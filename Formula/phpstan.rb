class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.9.14/phpstan.phar"
  sha256 "49b93c44cb71ceea8c485de3419356030da73a79b72ba1c2456a1b0bb604fa26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "294cded9ca4f931799e2ee35dd6c2eb24fe88a7045666cef0db5e65f3d4a11db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "294cded9ca4f931799e2ee35dd6c2eb24fe88a7045666cef0db5e65f3d4a11db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "294cded9ca4f931799e2ee35dd6c2eb24fe88a7045666cef0db5e65f3d4a11db"
    sha256 cellar: :any_skip_relocation, ventura:        "83ed6eba3903fcca1bce010f39555205c84d53569d51dd6da4862e12d559582f"
    sha256 cellar: :any_skip_relocation, monterey:       "83ed6eba3903fcca1bce010f39555205c84d53569d51dd6da4862e12d559582f"
    sha256 cellar: :any_skip_relocation, big_sur:        "83ed6eba3903fcca1bce010f39555205c84d53569d51dd6da4862e12d559582f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "294cded9ca4f931799e2ee35dd6c2eb24fe88a7045666cef0db5e65f3d4a11db"
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
