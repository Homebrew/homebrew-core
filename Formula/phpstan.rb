class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.7.11/phpstan.phar"
  sha256 "023553b7a95db004cea62a167aeaf61b5a472ae5c939c4f24e908b1e84d168b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2ce42b208d7a0982eda018dcb967b61df5c1f730573ed7fcc4a757ae8e4284b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2ce42b208d7a0982eda018dcb967b61df5c1f730573ed7fcc4a757ae8e4284b"
    sha256 cellar: :any_skip_relocation, monterey:       "c884059f505ce12d7ea8d099c0340618c972035dbde91bbe73227bd811a30efc"
    sha256 cellar: :any_skip_relocation, big_sur:        "c884059f505ce12d7ea8d099c0340618c972035dbde91bbe73227bd811a30efc"
    sha256 cellar: :any_skip_relocation, catalina:       "c884059f505ce12d7ea8d099c0340618c972035dbde91bbe73227bd811a30efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2ce42b208d7a0982eda018dcb967b61df5c1f730573ed7fcc4a757ae8e4284b"
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
