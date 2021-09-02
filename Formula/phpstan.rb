class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/0.12.98/phpstan.phar"
  sha256 "91b69b15e34ef27a51ccd5ebe5765c850166bb570980035c6bb633375330d51f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "372a9d4e836a5c71e750b25509693220b241d118fc9e5e33f1fb81e8adb88c31"
    sha256 cellar: :any_skip_relocation, big_sur:       "4052cfc4bfd7a9e7ac2432fbfad844926c520b936d4c9856ce0ffcae7b3332a1"
    sha256 cellar: :any_skip_relocation, catalina:      "4052cfc4bfd7a9e7ac2432fbfad844926c520b936d4c9856ce0ffcae7b3332a1"
    sha256 cellar: :any_skip_relocation, mojave:        "4052cfc4bfd7a9e7ac2432fbfad844926c520b936d4c9856ce0ffcae7b3332a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "372a9d4e836a5c71e750b25509693220b241d118fc9e5e33f1fb81e8adb88c31"
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
