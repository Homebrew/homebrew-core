class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.4.7/phpstan.phar"
  sha256 "6ec49d15f5154276c3147f213b567db07036c3ba4c1e52c4c7586c8037425261"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9471ae4c22a19b5f04c85eaac1669ee47ad0ee9f78650f6d84521881147630b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9471ae4c22a19b5f04c85eaac1669ee47ad0ee9f78650f6d84521881147630b"
    sha256 cellar: :any_skip_relocation, monterey:       "51da89a1852bd4c1866900ec418823a7c58cfb18737680a6e8e980316ad6eb21"
    sha256 cellar: :any_skip_relocation, big_sur:        "51da89a1852bd4c1866900ec418823a7c58cfb18737680a6e8e980316ad6eb21"
    sha256 cellar: :any_skip_relocation, catalina:       "51da89a1852bd4c1866900ec418823a7c58cfb18737680a6e8e980316ad6eb21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9471ae4c22a19b5f04c85eaac1669ee47ad0ee9f78650f6d84521881147630b"
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
