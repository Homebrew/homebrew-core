class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/2.1.14/phpstan.phar"
  sha256 "91f767184bc328019440ca8aad41689ac4acc9fa4bad50058f4331a24ac86a71"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc1e96b21b8e711a3f41f994cb0e22b9eb4b7f887cc0ace9fc24980a7a659b79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc1e96b21b8e711a3f41f994cb0e22b9eb4b7f887cc0ace9fc24980a7a659b79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc1e96b21b8e711a3f41f994cb0e22b9eb4b7f887cc0ace9fc24980a7a659b79"
    sha256 cellar: :any_skip_relocation, sonoma:        "96e08a94c264f4df70f916db882372d98360d7960cb8904e5f295b92486ae332"
    sha256 cellar: :any_skip_relocation, ventura:       "96e08a94c264f4df70f916db882372d98360d7960cb8904e5f295b92486ae332"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3eea15fb147042f630758beaa08454a00e31ebf3e69873d893ad36b4e5cd706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3eea15fb147042f630758beaa08454a00e31ebf3e69873d893ad36b4e5cd706"
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
