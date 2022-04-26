class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.6.1/phpstan.phar"
  sha256 "d9dc6f827a8c7183157271304c015042e4a4b0b280ab4b0b02ae99de55f20a8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "920d61ec10ec5bf7022a46768a1fa8186c2b1dbb13efd687c2f879078451f280"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "920d61ec10ec5bf7022a46768a1fa8186c2b1dbb13efd687c2f879078451f280"
    sha256 cellar: :any_skip_relocation, monterey:       "0a5eeea1323bb5e7f1b55cbb289ebcb99822f0d5896b29e35f626d6271b55e8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a5eeea1323bb5e7f1b55cbb289ebcb99822f0d5896b29e35f626d6271b55e8a"
    sha256 cellar: :any_skip_relocation, catalina:       "0a5eeea1323bb5e7f1b55cbb289ebcb99822f0d5896b29e35f626d6271b55e8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "920d61ec10ec5bf7022a46768a1fa8186c2b1dbb13efd687c2f879078451f280"
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
