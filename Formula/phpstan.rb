class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.5.7/phpstan.phar"
  sha256 "be5075bf6f63e2ebaeeb12e942fb1ed3a3d9e695e3f584a8d0964a14a476851b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b7d253933212499026102c9b114666957fc977ca472f70cdec9e5da632b9bfc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b7d253933212499026102c9b114666957fc977ca472f70cdec9e5da632b9bfc"
    sha256 cellar: :any_skip_relocation, monterey:       "8da747c73545f9f30fc06f87a073c3c75259b383b439d3b80f8d8fd9ce62046a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8da747c73545f9f30fc06f87a073c3c75259b383b439d3b80f8d8fd9ce62046a"
    sha256 cellar: :any_skip_relocation, catalina:       "8da747c73545f9f30fc06f87a073c3c75259b383b439d3b80f8d8fd9ce62046a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b7d253933212499026102c9b114666957fc977ca472f70cdec9e5da632b9bfc"
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
