class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.9.2/phpstan.phar"
  sha256 "34695f0aab2a3e271a78bc157c05bc6cd347f6d5a5f3eb019797f84aba469c6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc5597806f12a02f9f2c29c23578d41ba36a1264a61dfe4796662018bc229cae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc5597806f12a02f9f2c29c23578d41ba36a1264a61dfe4796662018bc229cae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc5597806f12a02f9f2c29c23578d41ba36a1264a61dfe4796662018bc229cae"
    sha256 cellar: :any_skip_relocation, ventura:        "7b8207f2ea89aab436e4322648338df2d9fadb6f3e39d08cadac5d5ff578d584"
    sha256 cellar: :any_skip_relocation, monterey:       "7b8207f2ea89aab436e4322648338df2d9fadb6f3e39d08cadac5d5ff578d584"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b8207f2ea89aab436e4322648338df2d9fadb6f3e39d08cadac5d5ff578d584"
    sha256 cellar: :any_skip_relocation, catalina:       "7b8207f2ea89aab436e4322648338df2d9fadb6f3e39d08cadac5d5ff578d584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc5597806f12a02f9f2c29c23578d41ba36a1264a61dfe4796662018bc229cae"
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
