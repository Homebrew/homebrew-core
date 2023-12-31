class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.50/phpstan.phar"
  sha256 "3ac7a423d6bcfccee1014261d1f25d3b7c1314063c350af6ca09efb4024b2939"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2e7dfb8cc40864ad5fbdd1e9905da2553c8bebf98d3d4258f8b469f0ae667c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2e7dfb8cc40864ad5fbdd1e9905da2553c8bebf98d3d4258f8b469f0ae667c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2e7dfb8cc40864ad5fbdd1e9905da2553c8bebf98d3d4258f8b469f0ae667c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0240d0ab30ce5e21d83052c918bf6f8f3a76fe18a7d4e47f34b61b84337f5d4"
    sha256 cellar: :any_skip_relocation, ventura:        "b0240d0ab30ce5e21d83052c918bf6f8f3a76fe18a7d4e47f34b61b84337f5d4"
    sha256 cellar: :any_skip_relocation, monterey:       "b0240d0ab30ce5e21d83052c918bf6f8f3a76fe18a7d4e47f34b61b84337f5d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2e7dfb8cc40864ad5fbdd1e9905da2553c8bebf98d3d4258f8b469f0ae667c0"
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
