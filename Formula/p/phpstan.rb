class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.38/phpstan.phar"
  sha256 "be8d21e5c9c96aff90aa2764509f8a04437286261e8060fda943411f56a49e2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8e0749b5d291807208b45844576daa31950762c30c2722d804533fd00806400"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8e0749b5d291807208b45844576daa31950762c30c2722d804533fd00806400"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8e0749b5d291807208b45844576daa31950762c30c2722d804533fd00806400"
    sha256 cellar: :any_skip_relocation, sonoma:         "73ad1b8b242e170eafa09c3e51f2f0144feca1424b02bb0ac9b37d8ae8513b2f"
    sha256 cellar: :any_skip_relocation, ventura:        "73ad1b8b242e170eafa09c3e51f2f0144feca1424b02bb0ac9b37d8ae8513b2f"
    sha256 cellar: :any_skip_relocation, monterey:       "73ad1b8b242e170eafa09c3e51f2f0144feca1424b02bb0ac9b37d8ae8513b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8e0749b5d291807208b45844576daa31950762c30c2722d804533fd00806400"
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
