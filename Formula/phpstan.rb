class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.9.9/phpstan.phar"
  sha256 "5858a6ee2c71eb94a2dece72542d9e11aaae5b141849b98eeecf6dc5e1fa403e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e218c88037cc383d22a295d2a993a13b6c3ba9ae769f00979ecd1e927f78262c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e218c88037cc383d22a295d2a993a13b6c3ba9ae769f00979ecd1e927f78262c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e218c88037cc383d22a295d2a993a13b6c3ba9ae769f00979ecd1e927f78262c"
    sha256 cellar: :any_skip_relocation, ventura:        "489e15499ec50f6f41250fecd82688c9a0f06ead4bd81f1303f6c630cf0e323b"
    sha256 cellar: :any_skip_relocation, monterey:       "489e15499ec50f6f41250fecd82688c9a0f06ead4bd81f1303f6c630cf0e323b"
    sha256 cellar: :any_skip_relocation, big_sur:        "489e15499ec50f6f41250fecd82688c9a0f06ead4bd81f1303f6c630cf0e323b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e218c88037cc383d22a295d2a993a13b6c3ba9ae769f00979ecd1e927f78262c"
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
