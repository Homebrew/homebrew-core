class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.21/phpstan.phar"
  sha256 "e9650860325db5832e9a9818fb1a36efb5c3fc46222e8ec98cfad79358ebc7b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b7731b9b3120610d4fd5f999cf904671900774d75cb90903f7183b115e476ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b7731b9b3120610d4fd5f999cf904671900774d75cb90903f7183b115e476ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b7731b9b3120610d4fd5f999cf904671900774d75cb90903f7183b115e476ff"
    sha256 cellar: :any_skip_relocation, ventura:        "c84c276972af52fb0fe3e1cac0baaea58a5a7f9edbdb4f67a04584b2b839557f"
    sha256 cellar: :any_skip_relocation, monterey:       "c84c276972af52fb0fe3e1cac0baaea58a5a7f9edbdb4f67a04584b2b839557f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c84c276972af52fb0fe3e1cac0baaea58a5a7f9edbdb4f67a04584b2b839557f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b7731b9b3120610d4fd5f999cf904671900774d75cb90903f7183b115e476ff"
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
