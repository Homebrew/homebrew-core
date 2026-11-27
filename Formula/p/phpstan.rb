class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://phpstan.org/"
  url "https://github.com/phpstan/phpstan/releases/download/2.3.7/phpstan.phar"
  sha256 "87fa9aa451bb9b61d7c65d40ec7d14d5bab67e3ad74ce75a09b3140d6f22631a"
  license "MIT"

  bottle do
    manifest_sha256 "a85d3eeedd0ce7cc434b94b0ad85a3fff88c96b2ca5b37224f5335bc1af8bbd9"
    sha256 cellar: :any_skip_relocation, all: "489e6990be90d839dc0aad077b4d5b8faa4a2386271b2f113d9e80156a2d60a7"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  allow_network_access! :test

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
