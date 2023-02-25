class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.3/phpstan.phar"
  sha256 "5928f101be8614c5c6657f4ff16c9461315e1a474efddb8a982f0366132ae316"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a88edc014bce1ebdbbf70575dc6049a0458bb569a5760f7199f7f4f85dfc257"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a88edc014bce1ebdbbf70575dc6049a0458bb569a5760f7199f7f4f85dfc257"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a88edc014bce1ebdbbf70575dc6049a0458bb569a5760f7199f7f4f85dfc257"
    sha256 cellar: :any_skip_relocation, ventura:        "8e8f06a8986bf80ea3b0856eb0ab903e4ff0e20d4a75ab7b802a5f77065dca18"
    sha256 cellar: :any_skip_relocation, monterey:       "8e8f06a8986bf80ea3b0856eb0ab903e4ff0e20d4a75ab7b802a5f77065dca18"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e8f06a8986bf80ea3b0856eb0ab903e4ff0e20d4a75ab7b802a5f77065dca18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a88edc014bce1ebdbbf70575dc6049a0458bb569a5760f7199f7f4f85dfc257"
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
