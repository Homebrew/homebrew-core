class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/4.19.0/psalm.phar"
  sha256 "7af93dc446701f303ee8a82c070118b654decc2ecc9251ee6577241d875d1fb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d71ae0c07a4dcc971637b88f4d651b92a39d6f1c9bd156a28d0fdf0d55647511"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d71ae0c07a4dcc971637b88f4d651b92a39d6f1c9bd156a28d0fdf0d55647511"
    sha256 cellar: :any_skip_relocation, monterey:       "9476091b3e2dcb05488443f5f7de4ba08e9313767ae38639e6ef28285562ca6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9476091b3e2dcb05488443f5f7de4ba08e9313767ae38639e6ef28285562ca6d"
    sha256 cellar: :any_skip_relocation, catalina:       "9476091b3e2dcb05488443f5f7de4ba08e9313767ae38639e6ef28285562ca6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d71ae0c07a4dcc971637b88f4d651b92a39d6f1c9bd156a28d0fdf0d55647511"
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
