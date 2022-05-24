class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/4.23.0/psalm.phar"
  sha256 "c38bcc077ca16152862c4cca5767d6661d556dc664acae10801d72783bdff169"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c980265fee3bcce532621be7fff0a9a96f43827b506f1c592342d00d66a6c4c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c980265fee3bcce532621be7fff0a9a96f43827b506f1c592342d00d66a6c4c7"
    sha256 cellar: :any_skip_relocation, monterey:       "22afe9d299e325d006f7b67055cb9614a7897f3d240dcb7d253102179b05aaed"
    sha256 cellar: :any_skip_relocation, big_sur:        "22afe9d299e325d006f7b67055cb9614a7897f3d240dcb7d253102179b05aaed"
    sha256 cellar: :any_skip_relocation, catalina:       "22afe9d299e325d006f7b67055cb9614a7897f3d240dcb7d253102179b05aaed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c980265fee3bcce532621be7fff0a9a96f43827b506f1c592342d00d66a6c4c7"
  end

  depends_on "composer" => :test
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
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
