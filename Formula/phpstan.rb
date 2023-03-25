class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.8/phpstan.phar"
  sha256 "bbd0fb261d705ee491cb094c32a7e72f1a90d93da8e4f0e8a01039bd91bd3b91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dde993debdc0be37dcf998259635ef3759d677b21ed512b816193a0292252b4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dde993debdc0be37dcf998259635ef3759d677b21ed512b816193a0292252b4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dde993debdc0be37dcf998259635ef3759d677b21ed512b816193a0292252b4a"
    sha256 cellar: :any_skip_relocation, ventura:        "1afe709b1d4d5fe2b27a88d701e1385d44e562c475f24fec2c8d5b07ca1a5fb4"
    sha256 cellar: :any_skip_relocation, monterey:       "1afe709b1d4d5fe2b27a88d701e1385d44e562c475f24fec2c8d5b07ca1a5fb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "1afe709b1d4d5fe2b27a88d701e1385d44e562c475f24fec2c8d5b07ca1a5fb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dde993debdc0be37dcf998259635ef3759d677b21ed512b816193a0292252b4a"
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
