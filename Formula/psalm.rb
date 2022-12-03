class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.1.0/psalm.phar"
  sha256 "8bb712e218c6e53d6c6244ae62703327e03afc7fc728a646fc4bc99f993457df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd9d9c843cec1eda8a39a50f4d9b5813fa6f6bddf3f996dc55692d4f0f7e721f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd9d9c843cec1eda8a39a50f4d9b5813fa6f6bddf3f996dc55692d4f0f7e721f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd9d9c843cec1eda8a39a50f4d9b5813fa6f6bddf3f996dc55692d4f0f7e721f"
    sha256 cellar: :any_skip_relocation, ventura:        "da4f05d7a01da1e819dd35f1c62784bc4f7beaeadbf7c38436c8376b98b51625"
    sha256 cellar: :any_skip_relocation, monterey:       "da4f05d7a01da1e819dd35f1c62784bc4f7beaeadbf7c38436c8376b98b51625"
    sha256 cellar: :any_skip_relocation, big_sur:        "da4f05d7a01da1e819dd35f1c62784bc4f7beaeadbf7c38436c8376b98b51625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd9d9c843cec1eda8a39a50f4d9b5813fa6f6bddf3f996dc55692d4f0f7e721f"
  end

  depends_on "composer" => :test
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "psalm.phar" => "psalm"
  end

  test do
    (testpath/"composer.json").write <<~EOS
      {
        "name": "homebrew/psalm-test",
        "description": "Testing if Psalm has been installed properly.",
        "type": "project",
        "require": {
          "php": ">=7.1.3"
        },
        "license": "MIT",
        "autoload": {
          "psr-4": {
            "Homebrew\\\\PsalmTest\\\\": "src/"
          }
        },
        "minimum-stability": "stable"
      }
    EOS

    (testpath/"src/Email.php").write <<~EOS
      <?php
      declare(strict_types=1);

      namespace Homebrew\\PsalmTest;

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
            throw new \\InvalidArgumentException(
              sprintf(
                '"%s" is not a valid email address',
                $email
              )
            );
          }
        }
      }
    EOS

    system "composer", "install"

    assert_match "Config file created successfully. Please re-run psalm.",
                 shell_output("#{bin}/psalm --init")
    assert_match "No errors found!",
                 shell_output("#{bin}/psalm")
  end
end
