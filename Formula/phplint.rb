class Phplint < Formula
  desc "Validator and documentator for PHP 5 and 7 programs"
  homepage "https://www.icosaedro.it/phplint/"
  url "https://www.icosaedro.it/phplint/phplint-4.0_20190206.tar.gz"
  version "4.0_20190206"
  sha256 "8a2d4b128fff23b469e5c64847187c2550d9775602f80859475ad686f2317cc0"

  bottle :unneeded

  depends_on "php"

  def install
    inreplace "php", "/opt/php/bin/php", Formula["php"].opt_bin/"php"
    libexec.install "modules", "php", "phpl", "stdlib", "utils"
    bin.install_symlink libexec/"phpl"
  end

  test do
    (testpath/"Email.php").write <<~EOS
      <?php
        declare(strict_types=1);

        final class Email
        {
            private $email;

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
    output = shell_output("#{bin}/phpl Email.php", 1)
    assert_match "Overall test results: 15 errors, 0 warnings.", output
  end
end
