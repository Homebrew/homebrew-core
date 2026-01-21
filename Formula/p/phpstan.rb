class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.35/phpstan.phar"
  sha256 "55ea59d34aab9276575d73b21bca65a2e8b3feef88dd78995223e7e37825f6ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e4a34773a799522d6b6b12ab46095e49db8a854dd5c535f3f39bf4903d31c5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e4a34773a799522d6b6b12ab46095e49db8a854dd5c535f3f39bf4903d31c5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e4a34773a799522d6b6b12ab46095e49db8a854dd5c535f3f39bf4903d31c5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a655eaf87065b2cb3c6b7a82391858eccc9a4fd29ecf3555deab28aa169c791"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a655eaf87065b2cb3c6b7a82391858eccc9a4fd29ecf3555deab28aa169c791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a655eaf87065b2cb3c6b7a82391858eccc9a4fd29ecf3555deab28aa169c791"
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
