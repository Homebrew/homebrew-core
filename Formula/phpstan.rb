class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.4/phpstan.phar"
  sha256 "26b4a4f630a13b904e2fa77b665131fed03e6c3ccb8f7678078e4c93aeea080b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd508fe1466df54e854500ad9f81a39895c77f7996bbe8a2ee12a592e0f05888"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd508fe1466df54e854500ad9f81a39895c77f7996bbe8a2ee12a592e0f05888"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd508fe1466df54e854500ad9f81a39895c77f7996bbe8a2ee12a592e0f05888"
    sha256 cellar: :any_skip_relocation, ventura:        "e7386f6ada83ea5f44e4fe6a2873e232e97e517585951d1a7f8716d8b3def827"
    sha256 cellar: :any_skip_relocation, monterey:       "e7386f6ada83ea5f44e4fe6a2873e232e97e517585951d1a7f8716d8b3def827"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7386f6ada83ea5f44e4fe6a2873e232e97e517585951d1a7f8716d8b3def827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd508fe1466df54e854500ad9f81a39895c77f7996bbe8a2ee12a592e0f05888"
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
