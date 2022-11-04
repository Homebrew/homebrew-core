class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.9.1/phpstan.phar"
  sha256 "6f2eb77106c012d72a9a2f4477219c879d0a8e9d3778b95d5e7f2cbc02443389"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "348641218943425d735232a967475f92721cde5964ac3ebd5c8e4b9e4993e58e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "348641218943425d735232a967475f92721cde5964ac3ebd5c8e4b9e4993e58e"
    sha256 cellar: :any_skip_relocation, monterey:       "b724798a99e8b1ee24bf90bc1fe570db10bba1748b6e7882f05e1b1305ce170a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b724798a99e8b1ee24bf90bc1fe570db10bba1748b6e7882f05e1b1305ce170a"
    sha256 cellar: :any_skip_relocation, catalina:       "b724798a99e8b1ee24bf90bc1fe570db10bba1748b6e7882f05e1b1305ce170a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "348641218943425d735232a967475f92721cde5964ac3ebd5c8e4b9e4993e58e"
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
