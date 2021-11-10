class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.1.2/phpstan.phar"
  sha256 "9e264c974a4405725d887b8fddab44d89b32dfee1ef7df8afa738410234555aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c696bf56e53b3b561c8a403c58cc66368655abbdf7f805f8e91a899a48ee270b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c696bf56e53b3b561c8a403c58cc66368655abbdf7f805f8e91a899a48ee270b"
    sha256 cellar: :any_skip_relocation, monterey:       "26efc2ac6cb00241ddaabbd0d7452cf1f3a28bcc3784322b5aa430819fd57a33"
    sha256 cellar: :any_skip_relocation, big_sur:        "26efc2ac6cb00241ddaabbd0d7452cf1f3a28bcc3784322b5aa430819fd57a33"
    sha256 cellar: :any_skip_relocation, catalina:       "26efc2ac6cb00241ddaabbd0d7452cf1f3a28bcc3784322b5aa430819fd57a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c696bf56e53b3b561c8a403c58cc66368655abbdf7f805f8e91a899a48ee270b"
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
