class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.7.15/phpstan.phar"
  sha256 "7c65a83ca9c699e977758e602d65bcb051c88beec626e5e25f448f1b610947a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32c0a8e1dc27ef1e589ecda5a8ccdfd610ef92568aa0ea4c7dbbab434fd13297"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32c0a8e1dc27ef1e589ecda5a8ccdfd610ef92568aa0ea4c7dbbab434fd13297"
    sha256 cellar: :any_skip_relocation, monterey:       "a15c82ea38212c058f57abce29d1540f8f89a9a0ac07298ae9e8a6ed6a09640e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a15c82ea38212c058f57abce29d1540f8f89a9a0ac07298ae9e8a6ed6a09640e"
    sha256 cellar: :any_skip_relocation, catalina:       "a15c82ea38212c058f57abce29d1540f8f89a9a0ac07298ae9e8a6ed6a09640e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32c0a8e1dc27ef1e589ecda5a8ccdfd610ef92568aa0ea4c7dbbab434fd13297"
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
