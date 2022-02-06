class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.4.6/phpstan.phar"
  sha256 "875f6b144b3b56b765c464b5a9e6099cee5a41a2b3a4565376c3768771e69b4c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56001289f2645f6284b7048045ce2898b346a50fd52f7246e1405627c99bc43f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56001289f2645f6284b7048045ce2898b346a50fd52f7246e1405627c99bc43f"
    sha256 cellar: :any_skip_relocation, monterey:       "55dcab1c9caca02cd5909740a471f21dec7aa812ae250062bfaec65f5a052b3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "55dcab1c9caca02cd5909740a471f21dec7aa812ae250062bfaec65f5a052b3b"
    sha256 cellar: :any_skip_relocation, catalina:       "55dcab1c9caca02cd5909740a471f21dec7aa812ae250062bfaec65f5a052b3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56001289f2645f6284b7048045ce2898b346a50fd52f7246e1405627c99bc43f"
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
