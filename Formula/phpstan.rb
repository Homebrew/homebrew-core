class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/0.12.96/phpstan.phar"
  sha256 "2427c1831db0261669308d8f500f3145a77635d4b8a6941c1394d6297bfecb33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "46addc6726950eb1ebcc8924a21f3d64164f8ae6bc2ab0ecf0523c22bcb02bbb"
    sha256 cellar: :any_skip_relocation, big_sur:       "afc399874c28086921ef2f4f47411389e79738726ed18ae5ef46ffe754ea4755"
    sha256 cellar: :any_skip_relocation, catalina:      "afc399874c28086921ef2f4f47411389e79738726ed18ae5ef46ffe754ea4755"
    sha256 cellar: :any_skip_relocation, mojave:        "afc399874c28086921ef2f4f47411389e79738726ed18ae5ef46ffe754ea4755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46addc6726950eb1ebcc8924a21f3d64164f8ae6bc2ab0ecf0523c22bcb02bbb"
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
