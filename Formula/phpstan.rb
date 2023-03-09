class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.6/phpstan.phar"
  sha256 "1a72fdb07d060344bca80ad0c2fbdf4e5686e3ae3187eb95eddc8702a9d9a63f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4a77d454c13b3778212451578377dff532d092c57bd0cf314845921491ef96b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4a77d454c13b3778212451578377dff532d092c57bd0cf314845921491ef96b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4a77d454c13b3778212451578377dff532d092c57bd0cf314845921491ef96b"
    sha256 cellar: :any_skip_relocation, ventura:        "c95c7e2672672920959a099e9f784e3fc8b63101c34a78094999fd241551df74"
    sha256 cellar: :any_skip_relocation, monterey:       "c95c7e2672672920959a099e9f784e3fc8b63101c34a78094999fd241551df74"
    sha256 cellar: :any_skip_relocation, big_sur:        "c95c7e2672672920959a099e9f784e3fc8b63101c34a78094999fd241551df74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4a77d454c13b3778212451578377dff532d092c57bd0cf314845921491ef96b"
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
