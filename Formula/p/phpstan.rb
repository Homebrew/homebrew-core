class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.2/phpstan.phar"
  sha256 "2c51773761fedf0d1a2be6dded91f02b49817f2963ae8690b273939dd2cdb1db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e1e6006508ed50e91c4eeb1e5941ba3ee457df76021bf579f9183653f175f04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e1e6006508ed50e91c4eeb1e5941ba3ee457df76021bf579f9183653f175f04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e1e6006508ed50e91c4eeb1e5941ba3ee457df76021bf579f9183653f175f04"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd63dbd96b6f4e10a84f538e8fc23adf280c475fc90c5b6bcb9c1a55ced5c21d"
    sha256 cellar: :any_skip_relocation, ventura:       "bd63dbd96b6f4e10a84f538e8fc23adf280c475fc90c5b6bcb9c1a55ced5c21d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "370f9e890267bfd05b4d0fe4c7e42d84e316d23428eb7c9134dfda459cdbb94c"
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
