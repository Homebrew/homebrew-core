class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.10.58/phpstan.phar"
  sha256 "c43705b7e833c09ef94d590a33422210db05ab9c627bfd5ce03fff55d45d97db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "282707f6fe9038aa564003020cf9495c2201cc9ac62a83a2defc5ccf06355b2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "282707f6fe9038aa564003020cf9495c2201cc9ac62a83a2defc5ccf06355b2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "282707f6fe9038aa564003020cf9495c2201cc9ac62a83a2defc5ccf06355b2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee559aaa743daa4fa777f14352fe7f2a474f63299681d2690331704677365ed0"
    sha256 cellar: :any_skip_relocation, ventura:        "ee559aaa743daa4fa777f14352fe7f2a474f63299681d2690331704677365ed0"
    sha256 cellar: :any_skip_relocation, monterey:       "ee559aaa743daa4fa777f14352fe7f2a474f63299681d2690331704677365ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "282707f6fe9038aa564003020cf9495c2201cc9ac62a83a2defc5ccf06355b2b"
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
