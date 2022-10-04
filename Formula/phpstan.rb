class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.8.7/phpstan.phar"
  sha256 "e90c9eb8457d772f784b2db83b139e36d296231d765bb52747739036f770614f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6e36d4b1472523465ecad3c73842353818e3e4286ad5c20cc66c593196566a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6e36d4b1472523465ecad3c73842353818e3e4286ad5c20cc66c593196566a3"
    sha256 cellar: :any_skip_relocation, monterey:       "3d448c81f605e33bc41111e311b426fbb65810dbcbfc0a799802b29d076c000a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d448c81f605e33bc41111e311b426fbb65810dbcbfc0a799802b29d076c000a"
    sha256 cellar: :any_skip_relocation, catalina:       "3d448c81f605e33bc41111e311b426fbb65810dbcbfc0a799802b29d076c000a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6e36d4b1472523465ecad3c73842353818e3e4286ad5c20cc66c593196566a3"
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
