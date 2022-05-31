class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.7.7/phpstan.phar"
  sha256 "fb77f92550b5a89927035d6e29e8d21440f5ee1464ba592f289bf9685240e9a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dc538f9a81e8754260fead6202209c4e87127d729a7e80efefe1d33bab5443c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7dc538f9a81e8754260fead6202209c4e87127d729a7e80efefe1d33bab5443c"
    sha256 cellar: :any_skip_relocation, monterey:       "b9c8ed202e4b47bca991fe234f57a3bfa2904c5025cc434b084946a68f242255"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9c8ed202e4b47bca991fe234f57a3bfa2904c5025cc434b084946a68f242255"
    sha256 cellar: :any_skip_relocation, catalina:       "b9c8ed202e4b47bca991fe234f57a3bfa2904c5025cc434b084946a68f242255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dc538f9a81e8754260fead6202209c4e87127d729a7e80efefe1d33bab5443c"
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
