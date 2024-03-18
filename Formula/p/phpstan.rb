class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.63/phpstan.phar"
  sha256 "7723e5d51b5a9846a14c263b8c497e3ac3f2983e08bfced7b57cb0b885b610cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a27b4ddb57bc468c82db27429bd216bdffa57b27159c3cf9cf768951c4f7ef7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a27b4ddb57bc468c82db27429bd216bdffa57b27159c3cf9cf768951c4f7ef7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a27b4ddb57bc468c82db27429bd216bdffa57b27159c3cf9cf768951c4f7ef7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7e39ff10dbf6eaa35d944a21645f76b6497c1c6a378471f9bd29b58825e7c36"
    sha256 cellar: :any_skip_relocation, ventura:        "c7e39ff10dbf6eaa35d944a21645f76b6497c1c6a378471f9bd29b58825e7c36"
    sha256 cellar: :any_skip_relocation, monterey:       "c7e39ff10dbf6eaa35d944a21645f76b6497c1c6a378471f9bd29b58825e7c36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a27b4ddb57bc468c82db27429bd216bdffa57b27159c3cf9cf768951c4f7ef7d"
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
