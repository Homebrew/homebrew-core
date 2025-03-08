class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.7/phpstan.phar"
  sha256 "eed523f448621e6d6af88ac885e451275604b6ad6dca0f970ee2cdfaf58bef9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b64971b895ce812fd547dc746654816d0227bc79d6775af02add3746d18f84ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b64971b895ce812fd547dc746654816d0227bc79d6775af02add3746d18f84ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b64971b895ce812fd547dc746654816d0227bc79d6775af02add3746d18f84ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e77a6f1b6aa92e6ac55ca8916f76210d57f4e204d3c00bfab845c83864861f4"
    sha256 cellar: :any_skip_relocation, ventura:       "1e77a6f1b6aa92e6ac55ca8916f76210d57f4e204d3c00bfab845c83864861f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f4d24fe004da7851dd2d6a1c4a1c14160efe4febe897557bc5705f8c7e437cf"
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
