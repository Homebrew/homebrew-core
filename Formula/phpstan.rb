class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.3.0/phpstan.phar"
  sha256 "dc1ee662e2b893c97a60f30c1d1776c91742afaf55b185e70196582030c320c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b653712eb14dcf40319517d6de661c2ef7734b1425451433d211a50ba8fad99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b653712eb14dcf40319517d6de661c2ef7734b1425451433d211a50ba8fad99"
    sha256 cellar: :any_skip_relocation, monterey:       "26ceab7bd9c5e9cf323ba102710a39e79804304d7985d64ccc19782c272b0bb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "26ceab7bd9c5e9cf323ba102710a39e79804304d7985d64ccc19782c272b0bb1"
    sha256 cellar: :any_skip_relocation, catalina:       "26ceab7bd9c5e9cf323ba102710a39e79804304d7985d64ccc19782c272b0bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b653712eb14dcf40319517d6de661c2ef7734b1425451433d211a50ba8fad99"
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
