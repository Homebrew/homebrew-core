class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.4.2/phpstan.phar"
  sha256 "3aab5cfc056d67db7e3dec6d23504ca8a3713e43b8f106403cbfd306b0dd8f20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c81df4477c3226b106fd8c128b0795a86f48b6a475fa8d9490e4bfcfba3f7d63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c81df4477c3226b106fd8c128b0795a86f48b6a475fa8d9490e4bfcfba3f7d63"
    sha256 cellar: :any_skip_relocation, monterey:       "b3fd6c251a66c3f3873fd465bcfd495acc75cb23a4bb6b9079da700eef319c8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3fd6c251a66c3f3873fd465bcfd495acc75cb23a4bb6b9079da700eef319c8c"
    sha256 cellar: :any_skip_relocation, catalina:       "b3fd6c251a66c3f3873fd465bcfd495acc75cb23a4bb6b9079da700eef319c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c81df4477c3226b106fd8c128b0795a86f48b6a475fa8d9490e4bfcfba3f7d63"
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
