class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.0/phpstan.phar"
  sha256 "c0cbf70630257cdad8f91c06a88d5ab4ab6729d26250be7c0504435cd7c21bf2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0193b120bd686adf1a71b84bf833ada60c47c3a5f99716fff7717a920ae234c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0193b120bd686adf1a71b84bf833ada60c47c3a5f99716fff7717a920ae234c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0193b120bd686adf1a71b84bf833ada60c47c3a5f99716fff7717a920ae234c7"
    sha256 cellar: :any_skip_relocation, ventura:        "9057ee5e7fcb1a46e9b2fb3bd83de1d66e6c138c97184a41a46b0f2309191690"
    sha256 cellar: :any_skip_relocation, monterey:       "9057ee5e7fcb1a46e9b2fb3bd83de1d66e6c138c97184a41a46b0f2309191690"
    sha256 cellar: :any_skip_relocation, big_sur:        "9057ee5e7fcb1a46e9b2fb3bd83de1d66e6c138c97184a41a46b0f2309191690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0193b120bd686adf1a71b84bf833ada60c47c3a5f99716fff7717a920ae234c7"
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
