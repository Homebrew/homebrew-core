class Phplint < Formula
  desc "Validator and documentator for PHP 5 and 7 programs"
  homepage "https://www.icosaedro.it/phplint/"
  url "https://www.icosaedro.it/phplint/phplint-4.2.0_20200308.tar.gz"
  version "4.2.0-20200308"
  sha256 "a0d0a726dc2662c1bc6fae95c904430b0c68d0b4e4e19c38777da38c2823a094"

  # The downloads page uses `href2` attributes instead of `href`.
  livecheck do
    url "https://www.icosaedro.it/phplint/download.html"
    regex(/href2?=.*?phplint[._-]v?(\d+(?:\.\d+)+(?:[._-]\d{6,8})?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecb11516875f096c647e254ef2451687ead874112397779abdb1afeafd8e0563"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14f43ce602719839c32da02be3464239085fbe253a38617305a51e5619cbb9b4"
    sha256 cellar: :any_skip_relocation, monterey:       "850a054845b3f52021d9afeaf0f36c0c946db3dba9741c01afb9238036e66fc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5191083b9faf95df4815a425a2b0e3a991bc578c5fef05f804663adcb057d1da"
    sha256 cellar: :any_skip_relocation, catalina:       "5191083b9faf95df4815a425a2b0e3a991bc578c5fef05f804663adcb057d1da"
    sha256 cellar: :any_skip_relocation, mojave:         "5191083b9faf95df4815a425a2b0e3a991bc578c5fef05f804663adcb057d1da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecb11516875f096c647e254ef2451687ead874112397779abdb1afeafd8e0563"
  end

  depends_on "php@7.4"

  def install
    inreplace "php", "/opt/php/bin/php", Formula["php@7.4"].opt_bin/"php"
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
    assert_match "Overall test results: 6 errors, 0 warnings.", output
  end
end
