class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.44/phpstan.phar"
  sha256 "ddb006c2c07d3110c71d23971f2f8b17ba2f2c4307649a635f758f94e25721f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df38464b1712d4f79bac77357586f202a04d49df4b6f4187faa30ca5dfe52cc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df38464b1712d4f79bac77357586f202a04d49df4b6f4187faa30ca5dfe52cc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df38464b1712d4f79bac77357586f202a04d49df4b6f4187faa30ca5dfe52cc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "a364ed61e5d2ee5b0dc3794d273172d3c8a5a8fd45dce369e698b117fe71bcdb"
    sha256 cellar: :any_skip_relocation, ventura:        "a364ed61e5d2ee5b0dc3794d273172d3c8a5a8fd45dce369e698b117fe71bcdb"
    sha256 cellar: :any_skip_relocation, monterey:       "a364ed61e5d2ee5b0dc3794d273172d3c8a5a8fd45dce369e698b117fe71bcdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df38464b1712d4f79bac77357586f202a04d49df4b6f4187faa30ca5dfe52cc9"
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
