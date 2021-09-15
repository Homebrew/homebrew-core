class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/0.12.99/phpstan.phar"
  sha256 "d8ac99e0e0f586d58942706bfe7e0939179bc4ae587b5f4b821ca1ee8beb6867"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e52cd4f982fd8c5cb0c571103a4cc9fabf46adc54c37e37b788dbfe08f2a56c4"
    sha256 cellar: :any_skip_relocation, big_sur:       "12b162929fe6f3891e3d0460e41f0dbfb582787534c5ace1a9e3ac7f05c3b7b7"
    sha256 cellar: :any_skip_relocation, catalina:      "12b162929fe6f3891e3d0460e41f0dbfb582787534c5ace1a9e3ac7f05c3b7b7"
    sha256 cellar: :any_skip_relocation, mojave:        "12b162929fe6f3891e3d0460e41f0dbfb582787534c5ace1a9e3ac7f05c3b7b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e52cd4f982fd8c5cb0c571103a4cc9fabf46adc54c37e37b788dbfe08f2a56c4"
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
