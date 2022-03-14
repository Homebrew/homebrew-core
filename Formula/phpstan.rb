class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.4.10/phpstan.phar"
  sha256 "2851b1be4f79671d5b38dc83919b093fb551ceb22749f376479364df0698cf5c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08d3400aff472764528c3fa742f9017614a887628eb840ca42b0df06343f723d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08d3400aff472764528c3fa742f9017614a887628eb840ca42b0df06343f723d"
    sha256 cellar: :any_skip_relocation, monterey:       "c215e6151879efb991dfe3dd5fe120ee157ff2051246b9028b19f6cbc9c0758e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c215e6151879efb991dfe3dd5fe120ee157ff2051246b9028b19f6cbc9c0758e"
    sha256 cellar: :any_skip_relocation, catalina:       "c215e6151879efb991dfe3dd5fe120ee157ff2051246b9028b19f6cbc9c0758e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08d3400aff472764528c3fa742f9017614a887628eb840ca42b0df06343f723d"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
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
