class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.30/phpstan.phar"
  sha256 "9b75057f287c127c257ae0cdfce36b82b5fe75f40114de9ed8f2e6a0b03e8100"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb939eb43e231b22af8554c9f4d2cc22ca421751dbdd4bd5855453f0c4a62e8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb939eb43e231b22af8554c9f4d2cc22ca421751dbdd4bd5855453f0c4a62e8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb939eb43e231b22af8554c9f4d2cc22ca421751dbdd4bd5855453f0c4a62e8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d879b82dbed84347af2c160862194c6754866eafb0361267adc2c9a6fee0b693"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d879b82dbed84347af2c160862194c6754866eafb0361267adc2c9a6fee0b693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d879b82dbed84347af2c160862194c6754866eafb0361267adc2c9a6fee0b693"
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
