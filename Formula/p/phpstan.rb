class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.27/phpstan.phar"
  sha256 "7dfa37d06541087403ed45ff8e7568a633872ff8c35ae262f97052b89f5eb165"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da21360833233eabc139fa17b30b48dd36ab6acaa34b7a7be96ea9a36f865057"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da21360833233eabc139fa17b30b48dd36ab6acaa34b7a7be96ea9a36f865057"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da21360833233eabc139fa17b30b48dd36ab6acaa34b7a7be96ea9a36f865057"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5d71dfe3b893994adb6ccbcae4f3224347a8b92d65a4242f8c944997f012eb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5d71dfe3b893994adb6ccbcae4f3224347a8b92d65a4242f8c944997f012eb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5d71dfe3b893994adb6ccbcae4f3224347a8b92d65a4242f8c944997f012eb2"
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
    (testpath/"src/autoload.php").write <<~PHP
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
    PHP

    (testpath/"src/Email.php").write <<~PHP
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
    PHP
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end
