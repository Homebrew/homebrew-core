class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/0.12.91/phpstan.phar"
  sha256 "0a238864c14caa9cd095413e827257a236b2b79acf0dd372cdab1c16b75defe4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "000b992c4a497d4e0f202b43adc26abb503d971198b50e61fd386b57d957a51d"
    sha256 cellar: :any_skip_relocation, big_sur:       "d3faddf8c86cb9c9fedfc8be42cf2f2201695af647a0aeec9f1f7c406ff6ad1a"
    sha256 cellar: :any_skip_relocation, catalina:      "d3faddf8c86cb9c9fedfc8be42cf2f2201695af647a0aeec9f1f7c406ff6ad1a"
    sha256 cellar: :any_skip_relocation, mojave:        "d3faddf8c86cb9c9fedfc8be42cf2f2201695af647a0aeec9f1f7c406ff6ad1a"
  end

  depends_on "php" => :test

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
