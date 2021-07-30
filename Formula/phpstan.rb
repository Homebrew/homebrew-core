class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/0.12.94/phpstan.phar"
  sha256 "f45d66ffda0f86abaf013e91b0f18e301ed7214b67eba82c71d66702d957a314"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b537c335364b0b4fd401341c96827e989c2e11fff8de267ead317b5f65ff3257"
    sha256 cellar: :any_skip_relocation, big_sur:       "00be2413cfa16c2a2a1ae4eef3b9be5b49ce2000d081fb85e456b30ed36ad3ef"
    sha256 cellar: :any_skip_relocation, catalina:      "00be2413cfa16c2a2a1ae4eef3b9be5b49ce2000d081fb85e456b30ed36ad3ef"
    sha256 cellar: :any_skip_relocation, mojave:        "00be2413cfa16c2a2a1ae4eef3b9be5b49ce2000d081fb85e456b30ed36ad3ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b537c335364b0b4fd401341c96827e989c2e11fff8de267ead317b5f65ff3257"
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
