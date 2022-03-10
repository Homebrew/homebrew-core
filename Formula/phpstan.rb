class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.4.9/phpstan.phar"
  sha256 "376a18861714eae08653325b2fcfef314972a496bf67ce9de1775dbe3ea4d5f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fc915d6a834f9fd06bcf6c5150c417346a07aa53012b00cdda880ecb7aeca87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fc915d6a834f9fd06bcf6c5150c417346a07aa53012b00cdda880ecb7aeca87"
    sha256 cellar: :any_skip_relocation, monterey:       "caf4c7bb7ce5efcedf3c8ce2caa3365ff829edf84868ddaae0eceaf878bf5c0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "caf4c7bb7ce5efcedf3c8ce2caa3365ff829edf84868ddaae0eceaf878bf5c0b"
    sha256 cellar: :any_skip_relocation, catalina:       "caf4c7bb7ce5efcedf3c8ce2caa3365ff829edf84868ddaae0eceaf878bf5c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fc915d6a834f9fd06bcf6c5150c417346a07aa53012b00cdda880ecb7aeca87"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
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
