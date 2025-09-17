class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.26/phpstan.phar"
  sha256 "4804919ce7b0c14e39cb52af6d3f5987bdcb70192358e44b2f736de39018c9fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee5b34712ceb1272de208964fe3df8fcd44b2bc33a79dfc7e6e9b6ce6b7fd204"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee5b34712ceb1272de208964fe3df8fcd44b2bc33a79dfc7e6e9b6ce6b7fd204"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee5b34712ceb1272de208964fe3df8fcd44b2bc33a79dfc7e6e9b6ce6b7fd204"
    sha256 cellar: :any_skip_relocation, sonoma:        "34316df7010283da45687f2933de9ca1db331b0c0df5f5731e9d97873e35067e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34316df7010283da45687f2933de9ca1db331b0c0df5f5731e9d97873e35067e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34316df7010283da45687f2933de9ca1db331b0c0df5f5731e9d97873e35067e"
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
    (testpath/"src/autoload.php").write <<~PHP
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
    PHP

    (testpath/"src/Email.php").write <<~PHP
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
    PHP
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end
