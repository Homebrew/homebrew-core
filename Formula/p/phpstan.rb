class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.12.7/phpstan.phar"
  sha256 "e5c896f4bf3afa9a2893d8f0ac00381f5b9a66de9b92f3c7955388aa18bc209d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bb9282f9027c67cedfcf35fb361c336ed47623af0c5c5de9efcafb4ef93d358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bb9282f9027c67cedfcf35fb361c336ed47623af0c5c5de9efcafb4ef93d358"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3bb9282f9027c67cedfcf35fb361c336ed47623af0c5c5de9efcafb4ef93d358"
    sha256 cellar: :any_skip_relocation, sonoma:        "54381d4e27974942e0167754b60d30bd73de2ad3d4b53562421ccd63f9565d2e"
    sha256 cellar: :any_skip_relocation, ventura:       "54381d4e27974942e0167754b60d30bd73de2ad3d4b53562421ccd63f9565d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "418d540f9b5412c12025c817f059b02b547b46ad70dc81d14f50357fe105bdf9"
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
