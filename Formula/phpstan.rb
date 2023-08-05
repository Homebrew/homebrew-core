class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.27/phpstan.phar"
  sha256 "26ad3fa2302b351c243fdc1ebb0be48014d5b3b631efa0e7774f5ce01a6873b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a2d09476093e749dfbef0ab6a1c37c2e491bd524070c5d21de827816db2fcc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a2d09476093e749dfbef0ab6a1c37c2e491bd524070c5d21de827816db2fcc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a2d09476093e749dfbef0ab6a1c37c2e491bd524070c5d21de827816db2fcc3"
    sha256 cellar: :any_skip_relocation, ventura:        "4334583ba2ab4569a2399e92c2780bd0e84fbfc5af26dca284a13c236a4d38a0"
    sha256 cellar: :any_skip_relocation, monterey:       "4334583ba2ab4569a2399e92c2780bd0e84fbfc5af26dca284a13c236a4d38a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4334583ba2ab4569a2399e92c2780bd0e84fbfc5af26dca284a13c236a4d38a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ddd4656f9e727fa1b28f76fad652664f049aff9532c1291a3e825415bb62345"
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
