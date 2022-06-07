class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.7.11/phpstan.phar"
  sha256 "023553b7a95db004cea62a167aeaf61b5a472ae5c939c4f24e908b1e84d168b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0d84d4c37810310d3bfc692de3a89e55248fe8f451ec25d3ca025848d8a07dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0d84d4c37810310d3bfc692de3a89e55248fe8f451ec25d3ca025848d8a07dd"
    sha256 cellar: :any_skip_relocation, monterey:       "4c468c4013f8ac17dbafa3a6782fb6f992a975f393d1e92698cf30065abdd5cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c468c4013f8ac17dbafa3a6782fb6f992a975f393d1e92698cf30065abdd5cf"
    sha256 cellar: :any_skip_relocation, catalina:       "4c468c4013f8ac17dbafa3a6782fb6f992a975f393d1e92698cf30065abdd5cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0d84d4c37810310d3bfc692de3a89e55248fe8f451ec25d3ca025848d8a07dd"
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
