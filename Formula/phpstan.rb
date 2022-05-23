class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.7.0/phpstan.phar"
  sha256 "8893c241e8dd412f54bb2adc860bb5b8706ef34b9d4122d40d2aac4773b70108"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6ac942c75b318aa9bf932b749459c219f2e6631a3072152b77bae60081971d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6ac942c75b318aa9bf932b749459c219f2e6631a3072152b77bae60081971d3"
    sha256 cellar: :any_skip_relocation, monterey:       "6d4f8fb6963f010ae937ee33c9b65adfea33b205ea9484449e911bad6cfcd17e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d4f8fb6963f010ae937ee33c9b65adfea33b205ea9484449e911bad6cfcd17e"
    sha256 cellar: :any_skip_relocation, catalina:       "6d4f8fb6963f010ae937ee33c9b65adfea33b205ea9484449e911bad6cfcd17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6ac942c75b318aa9bf932b749459c219f2e6631a3072152b77bae60081971d3"
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
