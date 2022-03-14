class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.4.10/phpstan.phar"
  sha256 "2851b1be4f79671d5b38dc83919b093fb551ceb22749f376479364df0698cf5c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "017b4d9594fd1dce422cd535abac271baea6f462f99fc5255cd0c1e82f53e5ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "017b4d9594fd1dce422cd535abac271baea6f462f99fc5255cd0c1e82f53e5ec"
    sha256 cellar: :any_skip_relocation, monterey:       "7e033e27ba4bc09e9b0c96d9e8341a2d151720519c772b5a7709fee193403214"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e033e27ba4bc09e9b0c96d9e8341a2d151720519c772b5a7709fee193403214"
    sha256 cellar: :any_skip_relocation, catalina:       "7e033e27ba4bc09e9b0c96d9e8341a2d151720519c772b5a7709fee193403214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "017b4d9594fd1dce422cd535abac271baea6f462f99fc5255cd0c1e82f53e5ec"
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
