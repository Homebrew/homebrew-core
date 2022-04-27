class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.6.2/phpstan.phar"
  sha256 "54f3923f1fd1b26e7f3618b91eb029904c1be0472e0f67ca82a72a9f01c1fb42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07841f145d9eed293c109c4d66e86f9f20091acc9d9ac2b9984f9445b2284503"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07841f145d9eed293c109c4d66e86f9f20091acc9d9ac2b9984f9445b2284503"
    sha256 cellar: :any_skip_relocation, monterey:       "ec29a478fa8f31621b9fef010d19750c5bda389e06d90cf838762ef0b0d67b34"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec29a478fa8f31621b9fef010d19750c5bda389e06d90cf838762ef0b0d67b34"
    sha256 cellar: :any_skip_relocation, catalina:       "ec29a478fa8f31621b9fef010d19750c5bda389e06d90cf838762ef0b0d67b34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07841f145d9eed293c109c4d66e86f9f20091acc9d9ac2b9984f9445b2284503"
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
