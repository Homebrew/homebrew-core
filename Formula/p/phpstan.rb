class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.64/phpstan.phar"
  sha256 "4d6d2ce48f6263e9882e7dd7f9b9e21af0126b01c4f99bfb1461413c819d553b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "422e6b88f71afcc9449b8cbae405892247b6c545b31f5d3ee33bef9264098854"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "422e6b88f71afcc9449b8cbae405892247b6c545b31f5d3ee33bef9264098854"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "422e6b88f71afcc9449b8cbae405892247b6c545b31f5d3ee33bef9264098854"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca5d106eed219fcd87b49b685473ce3896391f89531b18a0d10673144a309cf6"
    sha256 cellar: :any_skip_relocation, ventura:        "ca5d106eed219fcd87b49b685473ce3896391f89531b18a0d10673144a309cf6"
    sha256 cellar: :any_skip_relocation, monterey:       "ca5d106eed219fcd87b49b685473ce3896391f89531b18a0d10673144a309cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "422e6b88f71afcc9449b8cbae405892247b6c545b31f5d3ee33bef9264098854"
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
