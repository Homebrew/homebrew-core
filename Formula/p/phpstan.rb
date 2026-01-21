class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.36/phpstan.phar"
  sha256 "9711f41b56904b32605b380476d71654dba84f656d79170b32fc68ee849ef4fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e252d1c16eeecc8df678ad469cde4c7f52a40e2bc51990b5e553a2779b1b115c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e252d1c16eeecc8df678ad469cde4c7f52a40e2bc51990b5e553a2779b1b115c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e252d1c16eeecc8df678ad469cde4c7f52a40e2bc51990b5e553a2779b1b115c"
    sha256 cellar: :any_skip_relocation, sonoma:        "85d55f7c1f617d8575c6c6d6d58a29f7335b14c67e5c5a1c45634f26ae7db074"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85d55f7c1f617d8575c6c6d6d58a29f7335b14c67e5c5a1c45634f26ae7db074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85d55f7c1f617d8575c6c6d6d58a29f7335b14c67e5c5a1c45634f26ae7db074"
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
    (testpath/"src/autoload.php").write <<~PHP
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
    PHP

    (testpath/"src/Email.php").write <<~PHP
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
    PHP
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end
