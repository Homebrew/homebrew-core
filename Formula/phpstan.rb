class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.7.1/phpstan.phar"
  sha256 "bf5d9fd3b9c04545f215a0da3a144e9da165bc627736c5dba6bbc51f5d182cd6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7191a217b1584386bf44d500c767562d93e6a3cabbb2e1d3ac2d58a0963a5b7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7191a217b1584386bf44d500c767562d93e6a3cabbb2e1d3ac2d58a0963a5b7a"
    sha256 cellar: :any_skip_relocation, monterey:       "1b092b48d1ddf3fc8cbf0c09f47a968cdfadfc06d51327720f60f3313d2583cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b092b48d1ddf3fc8cbf0c09f47a968cdfadfc06d51327720f60f3313d2583cb"
    sha256 cellar: :any_skip_relocation, catalina:       "1b092b48d1ddf3fc8cbf0c09f47a968cdfadfc06d51327720f60f3313d2583cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7191a217b1584386bf44d500c767562d93e6a3cabbb2e1d3ac2d58a0963a5b7a"
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
