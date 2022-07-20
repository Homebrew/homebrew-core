class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.8.2/phpstan.phar"
  sha256 "3676c437d7613d406d80488a8f9981b56f519d313d8e6c7f66a45daa6bb22288"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a79782f93d9db99ed05db67b9f4bc9b64b942b1d7fe5e861d317e8bda3adc867"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a79782f93d9db99ed05db67b9f4bc9b64b942b1d7fe5e861d317e8bda3adc867"
    sha256 cellar: :any_skip_relocation, monterey:       "3f8c14eb54ec19796dddcd3d5f4ede4e421a8a4a7f854ba3a3b8c18461d599d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f8c14eb54ec19796dddcd3d5f4ede4e421a8a4a7f854ba3a3b8c18461d599d6"
    sha256 cellar: :any_skip_relocation, catalina:       "3f8c14eb54ec19796dddcd3d5f4ede4e421a8a4a7f854ba3a3b8c18461d599d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a79782f93d9db99ed05db67b9f4bc9b64b942b1d7fe5e861d317e8bda3adc867"
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
