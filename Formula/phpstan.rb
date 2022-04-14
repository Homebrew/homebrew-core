class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.5.5/phpstan.phar"
  sha256 "4ef0c97820db3faa60830d2e4e91305db5e0994608450bc3b17ee05065b4fa24"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de2d130120e67251f3201a00cb710eca2cdee4474b5f532995f99fde13e5640a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de2d130120e67251f3201a00cb710eca2cdee4474b5f532995f99fde13e5640a"
    sha256 cellar: :any_skip_relocation, monterey:       "9c24c3bd5859d9586fe2526b833a4bf42164cd177ac7f70ea07719cd88466157"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c24c3bd5859d9586fe2526b833a4bf42164cd177ac7f70ea07719cd88466157"
    sha256 cellar: :any_skip_relocation, catalina:       "9c24c3bd5859d9586fe2526b833a4bf42164cd177ac7f70ea07719cd88466157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de2d130120e67251f3201a00cb710eca2cdee4474b5f532995f99fde13e5640a"
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
