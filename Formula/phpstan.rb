class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.3.1/phpstan.phar"
  sha256 "554ba609fbd07d27385780ed8c5f2e42df19ba5c73cf81e550d2ad1016b3da30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "076a08c095c8dc0a4b72e7765eb0521b5617756aa2b5a1f11221ed3f7617689c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "076a08c095c8dc0a4b72e7765eb0521b5617756aa2b5a1f11221ed3f7617689c"
    sha256 cellar: :any_skip_relocation, monterey:       "1eda4dbf8a90c8b2e872b022e6a21b4a96d223f35970512967eb873546175d1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1eda4dbf8a90c8b2e872b022e6a21b4a96d223f35970512967eb873546175d1d"
    sha256 cellar: :any_skip_relocation, catalina:       "1eda4dbf8a90c8b2e872b022e6a21b4a96d223f35970512967eb873546175d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "076a08c095c8dc0a4b72e7765eb0521b5617756aa2b5a1f11221ed3f7617689c"
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
