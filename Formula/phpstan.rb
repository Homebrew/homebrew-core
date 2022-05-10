class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.6.8/phpstan.phar"
  sha256 "ae1544f77f9e854f03e5a9a0e952aea28f1ba8df32358631d43bb6871cad1344"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c95dd3e3c4315c716078fd9d674d2d84a592c04194768a9c56a90df21a29c1ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c95dd3e3c4315c716078fd9d674d2d84a592c04194768a9c56a90df21a29c1ee"
    sha256 cellar: :any_skip_relocation, monterey:       "1272839e91df89bb1b1d640d57f7f27d7f91a950858f5ee224436fd519267346"
    sha256 cellar: :any_skip_relocation, big_sur:        "1272839e91df89bb1b1d640d57f7f27d7f91a950858f5ee224436fd519267346"
    sha256 cellar: :any_skip_relocation, catalina:       "1272839e91df89bb1b1d640d57f7f27d7f91a950858f5ee224436fd519267346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c95dd3e3c4315c716078fd9d674d2d84a592c04194768a9c56a90df21a29c1ee"
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
