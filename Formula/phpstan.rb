class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.9.5/phpstan.phar"
  sha256 "c105b83bd7e7a0fac7e64e8cee074005b7618bdc06784ce1ed6976b4fe1bd656"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "437909e6fa53805e3545b408881e5707fb4c1dc244a1c6d7bc08c8fbb57fec18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "437909e6fa53805e3545b408881e5707fb4c1dc244a1c6d7bc08c8fbb57fec18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "437909e6fa53805e3545b408881e5707fb4c1dc244a1c6d7bc08c8fbb57fec18"
    sha256 cellar: :any_skip_relocation, ventura:        "7b8bf9522ddd7fca7df0fc54d6ef2a2c302f178b074ff9040a7a7d7067a0acd7"
    sha256 cellar: :any_skip_relocation, monterey:       "7b8bf9522ddd7fca7df0fc54d6ef2a2c302f178b074ff9040a7a7d7067a0acd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b8bf9522ddd7fca7df0fc54d6ef2a2c302f178b074ff9040a7a7d7067a0acd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "437909e6fa53805e3545b408881e5707fb4c1dc244a1c6d7bc08c8fbb57fec18"
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
