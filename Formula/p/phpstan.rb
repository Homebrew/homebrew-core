class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.65/phpstan.phar"
  sha256 "50773f5e579905bd287f3cdc8a2de7441c5bb9e26fe458147d02cb3ff49d21df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89d1ce0d46f17a8637c15285f9c8ef6c36c81c4838b701bc86aad31b26474ca7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89d1ce0d46f17a8637c15285f9c8ef6c36c81c4838b701bc86aad31b26474ca7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89d1ce0d46f17a8637c15285f9c8ef6c36c81c4838b701bc86aad31b26474ca7"
    sha256 cellar: :any_skip_relocation, sonoma:         "68d910e8550f8eee0c21c62f8e4c58d26458fcb795e527be0e55216014c70e83"
    sha256 cellar: :any_skip_relocation, ventura:        "68d910e8550f8eee0c21c62f8e4c58d26458fcb795e527be0e55216014c70e83"
    sha256 cellar: :any_skip_relocation, monterey:       "68d910e8550f8eee0c21c62f8e4c58d26458fcb795e527be0e55216014c70e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89d1ce0d46f17a8637c15285f9c8ef6c36c81c4838b701bc86aad31b26474ca7"
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
