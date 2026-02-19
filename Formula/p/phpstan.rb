class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.39/phpstan.phar"
  sha256 "a0f2501e5129b7cd40c4cb5abc256c636379494030fd9452b40e997d96d0323f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5629afd6eb40d18830767403f973be543feed07bd18912781b7e51c8f9d07f5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5629afd6eb40d18830767403f973be543feed07bd18912781b7e51c8f9d07f5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5629afd6eb40d18830767403f973be543feed07bd18912781b7e51c8f9d07f5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "77351578cba5f247f19cba7c9be82c2be268eb9364d3a7e2fd38d318bf6ad2fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77351578cba5f247f19cba7c9be82c2be268eb9364d3a7e2fd38d318bf6ad2fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77351578cba5f247f19cba7c9be82c2be268eb9364d3a7e2fd38d318bf6ad2fd"
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
