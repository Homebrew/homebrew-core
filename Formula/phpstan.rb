class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.7.14/phpstan.phar"
  sha256 "32946ce4ad365966f39faec71d81d09fbbb1ace2d23944950a397ef9ee293db7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88ca56d768a96ad50cafc695de6b9ea0e8292dd6ee294d795a472d4547373a5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88ca56d768a96ad50cafc695de6b9ea0e8292dd6ee294d795a472d4547373a5f"
    sha256 cellar: :any_skip_relocation, monterey:       "1698ca097b429206ad1e90b16ef9768252d4df3d896fb77e196e0edf06c2f549"
    sha256 cellar: :any_skip_relocation, big_sur:        "1698ca097b429206ad1e90b16ef9768252d4df3d896fb77e196e0edf06c2f549"
    sha256 cellar: :any_skip_relocation, catalina:       "1698ca097b429206ad1e90b16ef9768252d4df3d896fb77e196e0edf06c2f549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88ca56d768a96ad50cafc695de6b9ea0e8292dd6ee294d795a472d4547373a5f"
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
