class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.8.6/phpstan.phar"
  sha256 "f2c71477c053eaef6ba813e8697a33927e87f4f21617f3163564fdcbc4703e48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94eb05211b4f9b2f1c0077d4edec5316a6edb6f1ee516664909a4de5e08e3277"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94eb05211b4f9b2f1c0077d4edec5316a6edb6f1ee516664909a4de5e08e3277"
    sha256 cellar: :any_skip_relocation, monterey:       "c72af05ba46acae652382474f20868a91d232c80a519a72ce9c815250bdd70e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c72af05ba46acae652382474f20868a91d232c80a519a72ce9c815250bdd70e7"
    sha256 cellar: :any_skip_relocation, catalina:       "c72af05ba46acae652382474f20868a91d232c80a519a72ce9c815250bdd70e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94eb05211b4f9b2f1c0077d4edec5316a6edb6f1ee516664909a4de5e08e3277"
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
