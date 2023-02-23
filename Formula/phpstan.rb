class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.2/phpstan.phar"
  sha256 "7f17e27f56efccef1be808a199796d4e62134565a4c92e78389ea3a22db6aa4a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6317f19cb6a9b36a4f4e759c8c182b595e7bb8534b47840270e0e095009cb44b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6317f19cb6a9b36a4f4e759c8c182b595e7bb8534b47840270e0e095009cb44b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6317f19cb6a9b36a4f4e759c8c182b595e7bb8534b47840270e0e095009cb44b"
    sha256 cellar: :any_skip_relocation, ventura:        "8283ee3d79d01bd399f2c6033930738b364b984af081696e0c652d19ddb171e6"
    sha256 cellar: :any_skip_relocation, monterey:       "8283ee3d79d01bd399f2c6033930738b364b984af081696e0c652d19ddb171e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "8283ee3d79d01bd399f2c6033930738b364b984af081696e0c652d19ddb171e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6317f19cb6a9b36a4f4e759c8c182b595e7bb8534b47840270e0e095009cb44b"
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
