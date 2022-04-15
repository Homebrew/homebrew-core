class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.5.6/phpstan.phar"
  sha256 "ad7e1a237df4ae1093f827782ffb5eaddd3985b3fe791dbc2e1b9596a2c54a21"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7c6a94859f44c3720ff137171534586f73bdeeb833a08a5ea357408f34911d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7c6a94859f44c3720ff137171534586f73bdeeb833a08a5ea357408f34911d1"
    sha256 cellar: :any_skip_relocation, monterey:       "4004cda2dc4fd4a3dd52cc940927b6c546aaaf65770ac4d7fbaa72a4bd5187ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "4004cda2dc4fd4a3dd52cc940927b6c546aaaf65770ac4d7fbaa72a4bd5187ce"
    sha256 cellar: :any_skip_relocation, catalina:       "4004cda2dc4fd4a3dd52cc940927b6c546aaaf65770ac4d7fbaa72a4bd5187ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7c6a94859f44c3720ff137171534586f73bdeeb833a08a5ea357408f34911d1"
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
