class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.14/phpstan.phar"
  sha256 "760d07f85180ebc7a2147ab29295d154ca91bfc4bf2c28cb3c869689c391a4b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8f9699393f6d703add456b1236a9233731e34532775da8f52a39e89e7ba35b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8f9699393f6d703add456b1236a9233731e34532775da8f52a39e89e7ba35b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8f9699393f6d703add456b1236a9233731e34532775da8f52a39e89e7ba35b4"
    sha256 cellar: :any_skip_relocation, ventura:        "089a94b18ab6a43463834105de800de79eb5dc8f1672ce6f882c2a7dd5378cd2"
    sha256 cellar: :any_skip_relocation, monterey:       "089a94b18ab6a43463834105de800de79eb5dc8f1672ce6f882c2a7dd5378cd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "089a94b18ab6a43463834105de800de79eb5dc8f1672ce6f882c2a7dd5378cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f9699393f6d703add456b1236a9233731e34532775da8f52a39e89e7ba35b4"
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
