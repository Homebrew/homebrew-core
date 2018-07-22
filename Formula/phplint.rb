class Phplint < Formula
  desc "Validator and documentator for PHP 5 and 7 programs"
  homepage "http://www.icosaedro.it/phplint/"
  url "http://www.icosaedro.it/phplint/phplint-3.1_20180416.tar.gz"
  version "3.1-20180416"
  sha256 "7535bc6987d6079d537ca643c40ec9ebbc767c31ec2fc0f5811ed66736afa341"

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
    assert_match "Overall test results: 20 errors, 0 warnings.", output
  end
end
