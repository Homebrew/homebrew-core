class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.12.6/phpstan.phar"
  sha256 "54488aa8e0cfb461be3d4f995159be61c502c410de618d4a479a81f5d9372db9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd89542bc1fe413a8311014cd56d90a0a2199eeb49f782371823d513de21fc83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd89542bc1fe413a8311014cd56d90a0a2199eeb49f782371823d513de21fc83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd89542bc1fe413a8311014cd56d90a0a2199eeb49f782371823d513de21fc83"
    sha256 cellar: :any_skip_relocation, sonoma:        "217a1de2f654c5be13dd6ee2083a0b7613f55326ae99e49839df13422e386871"
    sha256 cellar: :any_skip_relocation, ventura:       "217a1de2f654c5be13dd6ee2083a0b7613f55326ae99e49839df13422e386871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f21c9f5e0451bf64971ebf2b5128737c8a52494e05a9b4d7311b8621d3ce7e3"
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
