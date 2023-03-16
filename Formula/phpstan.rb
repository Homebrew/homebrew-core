class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.7/phpstan.phar"
  sha256 "024da1b91c7fec6e72a8767e023e293cbb82abadf03c00d24693ac8b3cb5357b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37f71e378b92a2155a2664e2ca467a201358ca76f891cfe9a46e78fe340602e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37f71e378b92a2155a2664e2ca467a201358ca76f891cfe9a46e78fe340602e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37f71e378b92a2155a2664e2ca467a201358ca76f891cfe9a46e78fe340602e2"
    sha256 cellar: :any_skip_relocation, ventura:        "cfd50776c21ba87390b78fa566dcdfe71727018d751c5abf4edf34546d7d0556"
    sha256 cellar: :any_skip_relocation, monterey:       "cfd50776c21ba87390b78fa566dcdfe71727018d751c5abf4edf34546d7d0556"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfd50776c21ba87390b78fa566dcdfe71727018d751c5abf4edf34546d7d0556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37f71e378b92a2155a2664e2ca467a201358ca76f891cfe9a46e78fe340602e2"
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
