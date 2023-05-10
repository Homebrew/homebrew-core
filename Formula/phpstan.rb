class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.15/phpstan.phar"
  sha256 "cc6ac0810b6d02f19d469b8e07757f1a9acccdcd8d3326b8777318d5221f60e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "601cb30d38a328008985e6bce537fac422f29ac8264ac0c2483061ffb5b9ce83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "601cb30d38a328008985e6bce537fac422f29ac8264ac0c2483061ffb5b9ce83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "601cb30d38a328008985e6bce537fac422f29ac8264ac0c2483061ffb5b9ce83"
    sha256 cellar: :any_skip_relocation, ventura:        "e44ce28e146b9290e50fd92eb74c6387373d6b4bac255b7bfca2fa44315972a4"
    sha256 cellar: :any_skip_relocation, monterey:       "e44ce28e146b9290e50fd92eb74c6387373d6b4bac255b7bfca2fa44315972a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e44ce28e146b9290e50fd92eb74c6387373d6b4bac255b7bfca2fa44315972a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "601cb30d38a328008985e6bce537fac422f29ac8264ac0c2483061ffb5b9ce83"
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
