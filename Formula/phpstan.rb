class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.9.17/phpstan.phar"
  sha256 "ecd1cfcfa44e5631b2aa19d30e4846af5fdeaa4c9d5cb3e9bf6f0a87fd105888"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89fd5a4dc5736ca597e225f982d836af5f87cf3f84c94b2cfb40420732634f6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89fd5a4dc5736ca597e225f982d836af5f87cf3f84c94b2cfb40420732634f6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89fd5a4dc5736ca597e225f982d836af5f87cf3f84c94b2cfb40420732634f6b"
    sha256 cellar: :any_skip_relocation, ventura:        "8cf7b3ed1269b12c7fb3934733bb9b2d90ef417e4e5d7548a98cb079a89cf591"
    sha256 cellar: :any_skip_relocation, monterey:       "8cf7b3ed1269b12c7fb3934733bb9b2d90ef417e4e5d7548a98cb079a89cf591"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cf7b3ed1269b12c7fb3934733bb9b2d90ef417e4e5d7548a98cb079a89cf591"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89fd5a4dc5736ca597e225f982d836af5f87cf3f84c94b2cfb40420732634f6b"
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
