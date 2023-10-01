class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.35/phpstan.phar"
  sha256 "78e2a52f9874b3bbde114e44a015878df131e584d2fe24adc7d20d1f9e1f52ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f1063152112e79ddc74d7f363f23bf73edd0176daecb36db3fbec86ff4cf7f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f1063152112e79ddc74d7f363f23bf73edd0176daecb36db3fbec86ff4cf7f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f1063152112e79ddc74d7f363f23bf73edd0176daecb36db3fbec86ff4cf7f3"
    sha256 cellar: :any_skip_relocation, ventura:        "1edc155117e0769fffa329b724d428abe38295accb65794a30ae08ac1c470d21"
    sha256 cellar: :any_skip_relocation, monterey:       "1edc155117e0769fffa329b724d428abe38295accb65794a30ae08ac1c470d21"
    sha256 cellar: :any_skip_relocation, big_sur:        "1edc155117e0769fffa329b724d428abe38295accb65794a30ae08ac1c470d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f1063152112e79ddc74d7f363f23bf73edd0176daecb36db3fbec86ff4cf7f3"
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
