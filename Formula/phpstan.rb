class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.4.0/phpstan.phar"
  sha256 "fa6b6d5a372a174de51c907042264dedbed963d3795003e32b91ffa60700a946"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "578073acd0a62c79ac4fde6083d37e3ad024705fd00bfa421bba156cf9a84993"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "578073acd0a62c79ac4fde6083d37e3ad024705fd00bfa421bba156cf9a84993"
    sha256 cellar: :any_skip_relocation, monterey:       "1da67134265107a6946e6bc48a898a3906279018b94d235530ed38c734c07364"
    sha256 cellar: :any_skip_relocation, big_sur:        "1da67134265107a6946e6bc48a898a3906279018b94d235530ed38c734c07364"
    sha256 cellar: :any_skip_relocation, catalina:       "1da67134265107a6946e6bc48a898a3906279018b94d235530ed38c734c07364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "578073acd0a62c79ac4fde6083d37e3ad024705fd00bfa421bba156cf9a84993"
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
