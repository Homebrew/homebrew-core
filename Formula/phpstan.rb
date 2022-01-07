class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.3.3/phpstan.phar"
  sha256 "b83ee03d218db465479f7dc282e19a3712c892007df2e0d5ad45bdb7a3b796d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5acbcd30d0a506289259eac9985efbf7fcca785b4ef2cf8808a4f472027d3c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5acbcd30d0a506289259eac9985efbf7fcca785b4ef2cf8808a4f472027d3c1"
    sha256 cellar: :any_skip_relocation, monterey:       "22b9af468ab46a0f106b4cccf78a81137c019ddb5ad47bc01d81b7b228bae9d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "22b9af468ab46a0f106b4cccf78a81137c019ddb5ad47bc01d81b7b228bae9d9"
    sha256 cellar: :any_skip_relocation, catalina:       "22b9af468ab46a0f106b4cccf78a81137c019ddb5ad47bc01d81b7b228bae9d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5acbcd30d0a506289259eac9985efbf7fcca785b4ef2cf8808a4f472027d3c1"
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
