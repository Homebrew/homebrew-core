class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.5.1/phpstan.phar"
  sha256 "fa50c585b79c7ce578190913fdf6ba724ea51ebf57e3a96d8dd114b39e79d85c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3e111b76fb4883f8b99a94817d78c587b6d3890cb91e17705063ad3a4cead9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3e111b76fb4883f8b99a94817d78c587b6d3890cb91e17705063ad3a4cead9c"
    sha256 cellar: :any_skip_relocation, monterey:       "ea14d3ec91c66895861341434845fde6d2997f360c48a2c7ef2ccf0c38ac404f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea14d3ec91c66895861341434845fde6d2997f360c48a2c7ef2ccf0c38ac404f"
    sha256 cellar: :any_skip_relocation, catalina:       "ea14d3ec91c66895861341434845fde6d2997f360c48a2c7ef2ccf0c38ac404f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3e111b76fb4883f8b99a94817d78c587b6d3890cb91e17705063ad3a4cead9c"
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
