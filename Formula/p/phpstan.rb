class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.33/phpstan.phar"
  sha256 "74522e09562666be84d35f358de80ab3a777980f633e816aa0863e9725a5ecff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c5dfa41ddf67e79f4029576704abadd3d7dba2a5f268cb6185467600e10bb8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c5dfa41ddf67e79f4029576704abadd3d7dba2a5f268cb6185467600e10bb8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c5dfa41ddf67e79f4029576704abadd3d7dba2a5f268cb6185467600e10bb8f"
    sha256 cellar: :any_skip_relocation, ventura:        "c2c9c8ca01a51c19e669324cc461e9a05adaa3a96c0a439539cfacb07464cc04"
    sha256 cellar: :any_skip_relocation, monterey:       "c2c9c8ca01a51c19e669324cc461e9a05adaa3a96c0a439539cfacb07464cc04"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2c9c8ca01a51c19e669324cc461e9a05adaa3a96c0a439539cfacb07464cc04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c5dfa41ddf67e79f4029576704abadd3d7dba2a5f268cb6185467600e10bb8f"
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
