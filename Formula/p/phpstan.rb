class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.0.0/phpstan.phar"
  sha256 "0c0d795a85bb111a60c47ff9667550a52b922e726fc1d0aab1a04a2ce8f43b10"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "145d3cc970cc896d4a6178fe7050deab788d61383b7909d1c08f0ea3318f07b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "145d3cc970cc896d4a6178fe7050deab788d61383b7909d1c08f0ea3318f07b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "145d3cc970cc896d4a6178fe7050deab788d61383b7909d1c08f0ea3318f07b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aa7a7b48dc8cc1756928f0bdbedf75526d234d7932d2fb5dc3b7aa95f03ff60"
    sha256 cellar: :any_skip_relocation, ventura:       "5aa7a7b48dc8cc1756928f0bdbedf75526d234d7932d2fb5dc3b7aa95f03ff60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "609b2966253db2ec27130b2ec00e289d759dcb87b156986cabb6aa587e1bec06"
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
