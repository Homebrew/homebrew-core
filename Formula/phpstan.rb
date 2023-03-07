class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.5/phpstan.phar"
  sha256 "4afb3d61eaabac27db7e338c3f18c8d8e869fa7677d687ea9427c5adce51511a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77f40a6162c976a291325c7286cdeacbaf97f5e13fa06bec1600c225011e8355"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77f40a6162c976a291325c7286cdeacbaf97f5e13fa06bec1600c225011e8355"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77f40a6162c976a291325c7286cdeacbaf97f5e13fa06bec1600c225011e8355"
    sha256 cellar: :any_skip_relocation, ventura:        "12126c82db8b3b92088d942530fa3fe48b88b2060f5f6e1a993cc2c653be5432"
    sha256 cellar: :any_skip_relocation, monterey:       "12126c82db8b3b92088d942530fa3fe48b88b2060f5f6e1a993cc2c653be5432"
    sha256 cellar: :any_skip_relocation, big_sur:        "12126c82db8b3b92088d942530fa3fe48b88b2060f5f6e1a993cc2c653be5432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77f40a6162c976a291325c7286cdeacbaf97f5e13fa06bec1600c225011e8355"
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
