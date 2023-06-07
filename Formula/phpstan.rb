class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.18/phpstan.phar"
  sha256 "6df6279ac39e838acf3c3a55286220113dac067b4c956c28dfda11431c7b4410"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2da656083788af8252c18dfa934409026197a4111d37f5ad5e40e6a22c5406f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2da656083788af8252c18dfa934409026197a4111d37f5ad5e40e6a22c5406f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2da656083788af8252c18dfa934409026197a4111d37f5ad5e40e6a22c5406f6"
    sha256 cellar: :any_skip_relocation, ventura:        "e40e54855eca87cfc171c73ffbedb6e2cce1c0e951f965982ef8833daccfb8d7"
    sha256 cellar: :any_skip_relocation, monterey:       "e40e54855eca87cfc171c73ffbedb6e2cce1c0e951f965982ef8833daccfb8d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e40e54855eca87cfc171c73ffbedb6e2cce1c0e951f965982ef8833daccfb8d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2da656083788af8252c18dfa934409026197a4111d37f5ad5e40e6a22c5406f6"
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
