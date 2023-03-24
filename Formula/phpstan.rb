class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.8/phpstan.phar"
  sha256 "bbd0fb261d705ee491cb094c32a7e72f1a90d93da8e4f0e8a01039bd91bd3b91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea31483b5f1742f38315f56939cf054beb935bfec48525223b98f06067227465"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea31483b5f1742f38315f56939cf054beb935bfec48525223b98f06067227465"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea31483b5f1742f38315f56939cf054beb935bfec48525223b98f06067227465"
    sha256 cellar: :any_skip_relocation, ventura:        "7a8b04e6393b770aa81ef77238354c6b93b448d2f90b42dfea674ef91248119e"
    sha256 cellar: :any_skip_relocation, monterey:       "7a8b04e6393b770aa81ef77238354c6b93b448d2f90b42dfea674ef91248119e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a8b04e6393b770aa81ef77238354c6b93b448d2f90b42dfea674ef91248119e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea31483b5f1742f38315f56939cf054beb935bfec48525223b98f06067227465"
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
