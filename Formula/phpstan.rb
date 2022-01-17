class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.4.1/phpstan.phar"
  sha256 "7dd7a98c86122001a8e066a570d8bc7bc89dfbf1a4d4fc09cd530feba0de906d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ece0664ae72b29c0bf7119f76bb575079be47b855cfd2b4251cef7417c32ae96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ece0664ae72b29c0bf7119f76bb575079be47b855cfd2b4251cef7417c32ae96"
    sha256 cellar: :any_skip_relocation, monterey:       "a4041035bbd0ddb5b50b7c7dd83597aa5f3731edddfd45c23156ecd6147d14ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4041035bbd0ddb5b50b7c7dd83597aa5f3731edddfd45c23156ecd6147d14ca"
    sha256 cellar: :any_skip_relocation, catalina:       "a4041035bbd0ddb5b50b7c7dd83597aa5f3731edddfd45c23156ecd6147d14ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ece0664ae72b29c0bf7119f76bb575079be47b855cfd2b4251cef7417c32ae96"
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
