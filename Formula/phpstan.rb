class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.13/phpstan.phar"
  sha256 "c0506ba4c298bfe06af1c4a12e03aafdf391cfbeda06310449a5f303e864dc6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0894467fdf76fa1edb01d2009075663d967598c1140c7229749c94ad33688a2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0894467fdf76fa1edb01d2009075663d967598c1140c7229749c94ad33688a2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0894467fdf76fa1edb01d2009075663d967598c1140c7229749c94ad33688a2b"
    sha256 cellar: :any_skip_relocation, ventura:        "7fa39535ce8732f96d98ab8adf86b4441cc539dcc5275514854d4cf20b948c90"
    sha256 cellar: :any_skip_relocation, monterey:       "7fa39535ce8732f96d98ab8adf86b4441cc539dcc5275514854d4cf20b948c90"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fa39535ce8732f96d98ab8adf86b4441cc539dcc5275514854d4cf20b948c90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0894467fdf76fa1edb01d2009075663d967598c1140c7229749c94ad33688a2b"
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
