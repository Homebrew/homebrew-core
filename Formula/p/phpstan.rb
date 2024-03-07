class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.60/phpstan.phar"
  sha256 "f5d4e12382c58178b240668a9ff8e2678a5915d81dd68aed552f0a15bd058ad7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0aa80eba4b9708da1c0ca890abe1e863172f7fa7b19746c4dd6bfaa046b3a2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0aa80eba4b9708da1c0ca890abe1e863172f7fa7b19746c4dd6bfaa046b3a2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0aa80eba4b9708da1c0ca890abe1e863172f7fa7b19746c4dd6bfaa046b3a2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6529f2c426a9bc0bdd53d6fa97df7f2350b44ae9313472a56ee6862a7dda9b59"
    sha256 cellar: :any_skip_relocation, ventura:        "6529f2c426a9bc0bdd53d6fa97df7f2350b44ae9313472a56ee6862a7dda9b59"
    sha256 cellar: :any_skip_relocation, monterey:       "6529f2c426a9bc0bdd53d6fa97df7f2350b44ae9313472a56ee6862a7dda9b59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0aa80eba4b9708da1c0ca890abe1e863172f7fa7b19746c4dd6bfaa046b3a2c"
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
