class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.6.4/phpstan.phar"
  sha256 "b052d517f1d3e32fff41747079586bf8ed81d7d7402682d8fb179e4ee6756214"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bc65c154162e0487ef5ac515eebdb449560e29c74755a517ced0c8c9fdc45ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bc65c154162e0487ef5ac515eebdb449560e29c74755a517ced0c8c9fdc45ea"
    sha256 cellar: :any_skip_relocation, monterey:       "1dcaf09cce7c854d47ba598c031d93d61ed2c5befe74a291a8f2f1babb253173"
    sha256 cellar: :any_skip_relocation, big_sur:        "1dcaf09cce7c854d47ba598c031d93d61ed2c5befe74a291a8f2f1babb253173"
    sha256 cellar: :any_skip_relocation, catalina:       "1dcaf09cce7c854d47ba598c031d93d61ed2c5befe74a291a8f2f1babb253173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bc65c154162e0487ef5ac515eebdb449560e29c74755a517ced0c8c9fdc45ea"
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
