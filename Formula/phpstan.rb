class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.9.18/phpstan.phar"
  sha256 "cf55a9797ff7805e7ec80b6df99d2b89b1a8b28cd5cb82454a9d0743588e54fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e50525a5288a04b0ad8c9d7d6cea107a9513bb5f6fbeb6130722ed8aa9c3b303"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66c0f263583861707e4966eb3e4913dc73983132c37160a35ca1929c1cb5d170"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7db0e71236b6cd81029be3d3fd7fbe74b143968abd1241e4d095a6ccf0670261"
    sha256 cellar: :any_skip_relocation, ventura:        "0698310ae5b33317dd9ac069e43b76f2316120a5c9deb664166d1d4cc49f65f2"
    sha256 cellar: :any_skip_relocation, monterey:       "31b6f2d823d6187547b689779b97d70c48cb53ca9461e01af348d3e639f1965a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c6399b483192dcf29027cd839d7b86d2070094fdd315fa4d18e6cfb260102dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e64072b63d01351b90aea6241a18cff02bfe1e7071138f36fd369d2c2f6093dc"
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
