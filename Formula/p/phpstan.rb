class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.11/phpstan.phar"
  sha256 "b35ef013debe5e07a685e51ddda7f93a6396d0298cf14c5e0256e61395aada8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e30fc33793f7134cba53aaad5202384b4991e61f478b0a97afbeec177d6d1d7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e30fc33793f7134cba53aaad5202384b4991e61f478b0a97afbeec177d6d1d7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e30fc33793f7134cba53aaad5202384b4991e61f478b0a97afbeec177d6d1d7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5e85824d6ab994f61bf650a4e33eaeeec9e9d87b90c36dcf9931fd3ea26b33d"
    sha256 cellar: :any_skip_relocation, ventura:       "b5e85824d6ab994f61bf650a4e33eaeeec9e9d87b90c36dcf9931fd3ea26b33d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb74f96d6ec4271bf9e53b50e1a7f30b31b7a6b88ce818e95d4ceef1eaf768c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb74f96d6ec4271bf9e53b50e1a7f30b31b7a6b88ce818e95d4ceef1eaf768c8"
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
