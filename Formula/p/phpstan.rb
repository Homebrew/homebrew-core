class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.67/phpstan.phar"
  sha256 "264f7ef4ba69fe3b5e88e06bcd485598db46ef9c4220f7e98a1f71726e2f80d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e9d39d583a1c134adc11fb9a7e567cf29b0378c15324ef1c4fd295afdc4d917"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e9d39d583a1c134adc11fb9a7e567cf29b0378c15324ef1c4fd295afdc4d917"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e9d39d583a1c134adc11fb9a7e567cf29b0378c15324ef1c4fd295afdc4d917"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2bc846bc24d95478d52efdc6e23ccc1e547f6e1d15adc168c84c4add43d0194"
    sha256 cellar: :any_skip_relocation, ventura:        "a2bc846bc24d95478d52efdc6e23ccc1e547f6e1d15adc168c84c4add43d0194"
    sha256 cellar: :any_skip_relocation, monterey:       "a2bc846bc24d95478d52efdc6e23ccc1e547f6e1d15adc168c84c4add43d0194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e9d39d583a1c134adc11fb9a7e567cf29b0378c15324ef1c4fd295afdc4d917"
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
