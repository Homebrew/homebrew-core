class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.64/phpstan.phar"
  sha256 "4d6d2ce48f6263e9882e7dd7f9b9e21af0126b01c4f99bfb1461413c819d553b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "657d544ffa5c3ae7042a27463298531ce1d0a8b54ccd4f1b1740aead93263899"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "657d544ffa5c3ae7042a27463298531ce1d0a8b54ccd4f1b1740aead93263899"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "657d544ffa5c3ae7042a27463298531ce1d0a8b54ccd4f1b1740aead93263899"
    sha256 cellar: :any_skip_relocation, sonoma:         "79d2a7cdde86d1906ed7e04c8ae9ae4f9ea62cb2f32ea14b18908cf684550345"
    sha256 cellar: :any_skip_relocation, ventura:        "79d2a7cdde86d1906ed7e04c8ae9ae4f9ea62cb2f32ea14b18908cf684550345"
    sha256 cellar: :any_skip_relocation, monterey:       "79d2a7cdde86d1906ed7e04c8ae9ae4f9ea62cb2f32ea14b18908cf684550345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "657d544ffa5c3ae7042a27463298531ce1d0a8b54ccd4f1b1740aead93263899"
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
