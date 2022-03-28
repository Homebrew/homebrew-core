class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.5.1/phpstan.phar"
  sha256 "fa50c585b79c7ce578190913fdf6ba724ea51ebf57e3a96d8dd114b39e79d85c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef486ddfdf2909a38b5b368ef0d14d28bc26330fb2b255df5e2b0d7310f61aa5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef486ddfdf2909a38b5b368ef0d14d28bc26330fb2b255df5e2b0d7310f61aa5"
    sha256 cellar: :any_skip_relocation, monterey:       "ef8452d215e18c9722914f0f10730cc4d6035685b059e4cb2e6f89f74b15edbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef8452d215e18c9722914f0f10730cc4d6035685b059e4cb2e6f89f74b15edbf"
    sha256 cellar: :any_skip_relocation, catalina:       "ef8452d215e18c9722914f0f10730cc4d6035685b059e4cb2e6f89f74b15edbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef486ddfdf2909a38b5b368ef0d14d28bc26330fb2b255df5e2b0d7310f61aa5"
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
