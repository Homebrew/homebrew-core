class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.8.8/phpstan.phar"
  sha256 "68628a32688bcfce15ac8e78038c6a4bc740b637e2ad344bbde75cd24a4f72db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99fd0f80ff1f52db2820c3af39563abebadd96d0640c0984b9995055872aa29c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99fd0f80ff1f52db2820c3af39563abebadd96d0640c0984b9995055872aa29c"
    sha256 cellar: :any_skip_relocation, monterey:       "ef8c56f82b0ae5bb4d184256ea9bf73c9544338049d0d24f32ad6c3772b9dc1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef8c56f82b0ae5bb4d184256ea9bf73c9544338049d0d24f32ad6c3772b9dc1b"
    sha256 cellar: :any_skip_relocation, catalina:       "ef8c56f82b0ae5bb4d184256ea9bf73c9544338049d0d24f32ad6c3772b9dc1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99fd0f80ff1f52db2820c3af39563abebadd96d0640c0984b9995055872aa29c"
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
