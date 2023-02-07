class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.9.16/phpstan.phar"
  sha256 "48b5ae407b9dd5a11e6329f9f00c38b007ecb7f96e5f68b52451b58e066bf8d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "195ef62659cfdd899bfd279ab78ec67c669789cc4dd6792708a6d3594f463ae6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "195ef62659cfdd899bfd279ab78ec67c669789cc4dd6792708a6d3594f463ae6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "195ef62659cfdd899bfd279ab78ec67c669789cc4dd6792708a6d3594f463ae6"
    sha256 cellar: :any_skip_relocation, ventura:        "c7cbc3759364ae147f888e95bfaa1dbd90d89db7cad852a9ac001857c8264436"
    sha256 cellar: :any_skip_relocation, monterey:       "c7cbc3759364ae147f888e95bfaa1dbd90d89db7cad852a9ac001857c8264436"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7cbc3759364ae147f888e95bfaa1dbd90d89db7cad852a9ac001857c8264436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "195ef62659cfdd899bfd279ab78ec67c669789cc4dd6792708a6d3594f463ae6"
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
