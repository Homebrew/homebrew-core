class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.62/phpstan.phar"
  sha256 "3dd46967bc66b4f301066380bda472fc743f15f78b30e69d864915bf24ea8199"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e38477bbb31f393b3ba1545f6fa6129db4631789d75f5c095c750e19b0812a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e38477bbb31f393b3ba1545f6fa6129db4631789d75f5c095c750e19b0812a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e38477bbb31f393b3ba1545f6fa6129db4631789d75f5c095c750e19b0812a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cf24602b39b04201617fdaafafd8f636a329eb98cca3cdfc2fbdc0f907cc53f"
    sha256 cellar: :any_skip_relocation, ventura:        "1cf24602b39b04201617fdaafafd8f636a329eb98cca3cdfc2fbdc0f907cc53f"
    sha256 cellar: :any_skip_relocation, monterey:       "1cf24602b39b04201617fdaafafd8f636a329eb98cca3cdfc2fbdc0f907cc53f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e38477bbb31f393b3ba1545f6fa6129db4631789d75f5c095c750e19b0812a3"
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
