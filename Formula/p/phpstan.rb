class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.50/phpstan.phar"
  sha256 "3ac7a423d6bcfccee1014261d1f25d3b7c1314063c350af6ca09efb4024b2939"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6d4e316111224b8d9ea83f03a782daf2cf9978804bde5d4c467b249990e7b1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6d4e316111224b8d9ea83f03a782daf2cf9978804bde5d4c467b249990e7b1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6d4e316111224b8d9ea83f03a782daf2cf9978804bde5d4c467b249990e7b1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8c13482a0efd7170a5cec63512d98cca2c2acc543612c92d74a0ab58954df2d"
    sha256 cellar: :any_skip_relocation, ventura:        "f8c13482a0efd7170a5cec63512d98cca2c2acc543612c92d74a0ab58954df2d"
    sha256 cellar: :any_skip_relocation, monterey:       "f8c13482a0efd7170a5cec63512d98cca2c2acc543612c92d74a0ab58954df2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6d4e316111224b8d9ea83f03a782daf2cf9978804bde5d4c467b249990e7b1e"
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
