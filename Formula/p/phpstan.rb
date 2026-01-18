class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.33/phpstan.phar"
  sha256 "48caad125554d6b416159db71dd7fd890295ba1a24b3650b49e32752e24fd6a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98bcd9bc66743da7c25eecd509d4294c7f525bdf93635b87033f9e1d2d3595e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98bcd9bc66743da7c25eecd509d4294c7f525bdf93635b87033f9e1d2d3595e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98bcd9bc66743da7c25eecd509d4294c7f525bdf93635b87033f9e1d2d3595e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a051c9c0e01c618f3e2b5128971f692b5c3a91d59fc5c4e7588efeab85556bd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a051c9c0e01c618f3e2b5128971f692b5c3a91d59fc5c4e7588efeab85556bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a051c9c0e01c618f3e2b5128971f692b5c3a91d59fc5c4e7588efeab85556bd8"
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
