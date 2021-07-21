class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/0.12.93/phpstan.phar"
  sha256 "007bd9a4afcc31987ed02d73c758b4f91e789ed8e7e0ceb2e9445bd22913d4ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ccb47d073983130326a6d3c4353ddab10a2ea29b5a5dfc3bd83965fc0c3a7194"
    sha256 cellar: :any_skip_relocation, big_sur:       "8ab74f29406da1f00022587e468ffe43600016682bc5a5aec5db34d7f2521ed4"
    sha256 cellar: :any_skip_relocation, catalina:      "8ab74f29406da1f00022587e468ffe43600016682bc5a5aec5db34d7f2521ed4"
    sha256 cellar: :any_skip_relocation, mojave:        "8ab74f29406da1f00022587e468ffe43600016682bc5a5aec5db34d7f2521ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccb47d073983130326a6d3c4353ddab10a2ea29b5a5dfc3bd83965fc0c3a7194"
  end

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  pour_bottle? do
    on_macos do
      reason "The bottle needs to be installed into `#{Homebrew::DEFAULT_PREFIX}` on Intel macOS."
      satisfy { HOMEBREW_PREFIX.to_s == Homebrew::DEFAULT_PREFIX || Hardware::CPU.arm? }
    end
  end

  depends_on "php" => :test

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
