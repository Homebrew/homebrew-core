class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.9.14/phpstan.phar"
  sha256 "49b93c44cb71ceea8c485de3419356030da73a79b72ba1c2456a1b0bb604fa26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16bf59fd634f0f682a04a96b27b9cdc56f18f11a6b18d41b6c2d9e5249822cb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16bf59fd634f0f682a04a96b27b9cdc56f18f11a6b18d41b6c2d9e5249822cb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16bf59fd634f0f682a04a96b27b9cdc56f18f11a6b18d41b6c2d9e5249822cb6"
    sha256 cellar: :any_skip_relocation, ventura:        "b4688ad0907f23212bc5c2f902103db3fa6b3799fccfd39c65ca5a18afc4dd09"
    sha256 cellar: :any_skip_relocation, monterey:       "b4688ad0907f23212bc5c2f902103db3fa6b3799fccfd39c65ca5a18afc4dd09"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4688ad0907f23212bc5c2f902103db3fa6b3799fccfd39c65ca5a18afc4dd09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16bf59fd634f0f682a04a96b27b9cdc56f18f11a6b18d41b6c2d9e5249822cb6"
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
