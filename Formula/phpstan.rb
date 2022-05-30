class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.7.6/phpstan.phar"
  sha256 "d666786ba9cc6b37e84375dc92679637a8b23b0d7561a7abf985dc1f9386e39b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72d84ec17e72b6d4cf905c3f2cb12413fe061999d420e7f0f8da20f0a312f96c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72d84ec17e72b6d4cf905c3f2cb12413fe061999d420e7f0f8da20f0a312f96c"
    sha256 cellar: :any_skip_relocation, monterey:       "b574bcc74d9121bbcace26d6a146ead7b259a65561329807b46035e32e557703"
    sha256 cellar: :any_skip_relocation, big_sur:        "b574bcc74d9121bbcace26d6a146ead7b259a65561329807b46035e32e557703"
    sha256 cellar: :any_skip_relocation, catalina:       "b574bcc74d9121bbcace26d6a146ead7b259a65561329807b46035e32e557703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72d84ec17e72b6d4cf905c3f2cb12413fe061999d420e7f0f8da20f0a312f96c"
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
