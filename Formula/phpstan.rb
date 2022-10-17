class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.8.10/phpstan.phar"
  sha256 "dabe01ab6d7d4ebc6350c86ac8a4671ff49b618711202726e16c1da5432e1c7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c9910b8cc324433a01ab6f5a24d5aebac7033fecb6af927ebed1bbac029cd5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c9910b8cc324433a01ab6f5a24d5aebac7033fecb6af927ebed1bbac029cd5a"
    sha256 cellar: :any_skip_relocation, monterey:       "d5647d230789b70cbd3c24003bd814a50a4e2aa19b4fd5df8fadaacd73d0e378"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5647d230789b70cbd3c24003bd814a50a4e2aa19b4fd5df8fadaacd73d0e378"
    sha256 cellar: :any_skip_relocation, catalina:       "d5647d230789b70cbd3c24003bd814a50a4e2aa19b4fd5df8fadaacd73d0e378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c9910b8cc324433a01ab6f5a24d5aebac7033fecb6af927ebed1bbac029cd5a"
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
