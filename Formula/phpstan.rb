class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.7.5/phpstan.phar"
  sha256 "4baa7dfdd9571931637f1e0ecec9e2115c49c8889fef5f8bce20e21d32281f5a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24e4958133f112b6d9f474c3fc273918babfcb6458d907fdf6ef7c782888ab20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24e4958133f112b6d9f474c3fc273918babfcb6458d907fdf6ef7c782888ab20"
    sha256 cellar: :any_skip_relocation, monterey:       "545dfce4e3ad66f9145b3dd3be942cc719f425d9ee3cedfee69678dae1f195e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "545dfce4e3ad66f9145b3dd3be942cc719f425d9ee3cedfee69678dae1f195e7"
    sha256 cellar: :any_skip_relocation, catalina:       "545dfce4e3ad66f9145b3dd3be942cc719f425d9ee3cedfee69678dae1f195e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24e4958133f112b6d9f474c3fc273918babfcb6458d907fdf6ef7c782888ab20"
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
