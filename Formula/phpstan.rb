class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.3.2/phpstan.phar"
  sha256 "24eade601d1e4e6ab2d0c0878a928455e2ef78504734b420955b010aa2a9cadc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2f40920df494246aa79749c86958de394d52e6c0e5136280ffd74e8e4a2fa69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2f40920df494246aa79749c86958de394d52e6c0e5136280ffd74e8e4a2fa69"
    sha256 cellar: :any_skip_relocation, monterey:       "f32157ce10971b81cc0fd24131522a826a2628028bca414f3ea1598521aaf57d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f32157ce10971b81cc0fd24131522a826a2628028bca414f3ea1598521aaf57d"
    sha256 cellar: :any_skip_relocation, catalina:       "f32157ce10971b81cc0fd24131522a826a2628028bca414f3ea1598521aaf57d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2f40920df494246aa79749c86958de394d52e6c0e5136280ffd74e8e4a2fa69"
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
