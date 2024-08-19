class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.11.11/phpstan.phar"
  sha256 "cc58c829c2d2609dc585ca3113a6e0f8d27c204c014da05a181874c2de23004c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51b3027e604b79ca2f9a76997f50120c7262bd4208c251f36809ba4c26707c37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51b3027e604b79ca2f9a76997f50120c7262bd4208c251f36809ba4c26707c37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51b3027e604b79ca2f9a76997f50120c7262bd4208c251f36809ba4c26707c37"
    sha256 cellar: :any_skip_relocation, sonoma:         "61df54e2cc7a3e3ed7886749f1607b5a749994f96d6c438aa6edc7bbd20cb3a6"
    sha256 cellar: :any_skip_relocation, ventura:        "61df54e2cc7a3e3ed7886749f1607b5a749994f96d6c438aa6edc7bbd20cb3a6"
    sha256 cellar: :any_skip_relocation, monterey:       "61df54e2cc7a3e3ed7886749f1607b5a749994f96d6c438aa6edc7bbd20cb3a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2af41d3fcca3429e8aae4cfce4f94c8596b1d4c2560e48fe99e19a6a0e36609e"
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
