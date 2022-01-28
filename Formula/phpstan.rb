class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.4.3/phpstan.phar"
  sha256 "c9a622eb81ae4b9aabdfdb6cba8b7bc3f5d3fc5ee79c0407b0d16203895b8702"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc0c994f6d6ad7335c0539adf84fca1bdbec27bf9a81fbf58db644c76fe7a4fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc0c994f6d6ad7335c0539adf84fca1bdbec27bf9a81fbf58db644c76fe7a4fd"
    sha256 cellar: :any_skip_relocation, monterey:       "f5a3a6d510fa0126b7d933401a016e998532966d5486b601097c16ab186c0611"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5a3a6d510fa0126b7d933401a016e998532966d5486b601097c16ab186c0611"
    sha256 cellar: :any_skip_relocation, catalina:       "f5a3a6d510fa0126b7d933401a016e998532966d5486b601097c16ab186c0611"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc0c994f6d6ad7335c0539adf84fca1bdbec27bf9a81fbf58db644c76fe7a4fd"
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
