class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.11.4/phpstan.phar"
  sha256 "81d6c6a79b8e68c1e21315290b614d2fb7dfae775dd4021c92abc2b0b07a02c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "737f25e4b5624c723127461c6e6315e72e412712436b3505d1386b39bb9ed0c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "737f25e4b5624c723127461c6e6315e72e412712436b3505d1386b39bb9ed0c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "737f25e4b5624c723127461c6e6315e72e412712436b3505d1386b39bb9ed0c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "762b679121c08ed26bc6a3b4cea4c76cce2830e3bbdebb3134eb089a0bbaa284"
    sha256 cellar: :any_skip_relocation, ventura:        "762b679121c08ed26bc6a3b4cea4c76cce2830e3bbdebb3134eb089a0bbaa284"
    sha256 cellar: :any_skip_relocation, monterey:       "762b679121c08ed26bc6a3b4cea4c76cce2830e3bbdebb3134eb089a0bbaa284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54a5607f5d35bf9881a52f35936e130ae128bd470653d4a6cf2291534c89e251"
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
