class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.9.5/phpstan.phar"
  sha256 "c105b83bd7e7a0fac7e64e8cee074005b7618bdc06784ce1ed6976b4fe1bd656"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc3661229b9096a0146925a47d43c5f1c33bdd6951b18a8ac48d05c868d92def"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc3661229b9096a0146925a47d43c5f1c33bdd6951b18a8ac48d05c868d92def"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc3661229b9096a0146925a47d43c5f1c33bdd6951b18a8ac48d05c868d92def"
    sha256 cellar: :any_skip_relocation, ventura:        "6edf35bdf6f164e00583fb4594da5608d05b3feef78f267bb5d3d8fdf3009de9"
    sha256 cellar: :any_skip_relocation, monterey:       "6edf35bdf6f164e00583fb4594da5608d05b3feef78f267bb5d3d8fdf3009de9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6edf35bdf6f164e00583fb4594da5608d05b3feef78f267bb5d3d8fdf3009de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc3661229b9096a0146925a47d43c5f1c33bdd6951b18a8ac48d05c868d92def"
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
