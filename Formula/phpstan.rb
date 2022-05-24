class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.7.1/phpstan.phar"
  sha256 "bf5d9fd3b9c04545f215a0da3a144e9da165bc627736c5dba6bbc51f5d182cd6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e6e11d11fcfcb82070e2e62abd36f3cb66a3c4206f9f1057c61aae5d940d797"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e6e11d11fcfcb82070e2e62abd36f3cb66a3c4206f9f1057c61aae5d940d797"
    sha256 cellar: :any_skip_relocation, monterey:       "2202c7e20931cb56fc88e98f4e81791fe576f6d767463b53f4c1851d930650e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2202c7e20931cb56fc88e98f4e81791fe576f6d767463b53f4c1851d930650e7"
    sha256 cellar: :any_skip_relocation, catalina:       "2202c7e20931cb56fc88e98f4e81791fe576f6d767463b53f4c1851d930650e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e6e11d11fcfcb82070e2e62abd36f3cb66a3c4206f9f1057c61aae5d940d797"
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
