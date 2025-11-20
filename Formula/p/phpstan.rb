class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.32/phpstan.phar"
  sha256 "14a4a22c51c88d00370e0c43d0d2b4f5d31f46a1e38d692bca1f803096d1a625"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f85983db98763bd303aa30346a237124bf1a831b0bded358ac515d0dcec641a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f85983db98763bd303aa30346a237124bf1a831b0bded358ac515d0dcec641a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f85983db98763bd303aa30346a237124bf1a831b0bded358ac515d0dcec641a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "98d40580d66b68c5e5561dd0fddec3d4852b195c1832c4f7275a181d440bbab9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98d40580d66b68c5e5561dd0fddec3d4852b195c1832c4f7275a181d440bbab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98d40580d66b68c5e5561dd0fddec3d4852b195c1832c4f7275a181d440bbab9"
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
