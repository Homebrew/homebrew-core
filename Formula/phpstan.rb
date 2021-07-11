class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/0.12.92/phpstan.phar"
  sha256 "2b753c3fe0b4d134359e64eea367d20ac2c36c9991d8ee61a07a305afd5b1eb6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0be119b1a69c5caf69f8f5f46b563bdc5d415ef376c2ded62f81662519dc66d9"
    sha256 cellar: :any_skip_relocation, big_sur:       "2ab5ea2de9514ee3ab0f8c29ce04a3704dd5cad418aa205c71152e66e3bf0081"
    sha256 cellar: :any_skip_relocation, catalina:      "2ab5ea2de9514ee3ab0f8c29ce04a3704dd5cad418aa205c71152e66e3bf0081"
    sha256 cellar: :any_skip_relocation, mojave:        "2ab5ea2de9514ee3ab0f8c29ce04a3704dd5cad418aa205c71152e66e3bf0081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0be119b1a69c5caf69f8f5f46b563bdc5d415ef376c2ded62f81662519dc66d9"
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
