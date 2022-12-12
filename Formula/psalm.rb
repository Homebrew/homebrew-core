class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.2.0/psalm.phar"
  sha256 "ca5baa3929361181119d2d33ee89038d97a59c9c39bf48ba438205800e13334c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df98774e92cd6c09cad15ccbd22f223ee09a3b036f634c7d66f0a45574b85173"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df98774e92cd6c09cad15ccbd22f223ee09a3b036f634c7d66f0a45574b85173"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df98774e92cd6c09cad15ccbd22f223ee09a3b036f634c7d66f0a45574b85173"
    sha256 cellar: :any_skip_relocation, ventura:        "302aa117abb96218bbd43f87a5c47c52f0f97ea18457e74b354707543ac2f409"
    sha256 cellar: :any_skip_relocation, monterey:       "302aa117abb96218bbd43f87a5c47c52f0f97ea18457e74b354707543ac2f409"
    sha256 cellar: :any_skip_relocation, big_sur:        "302aa117abb96218bbd43f87a5c47c52f0f97ea18457e74b354707543ac2f409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df98774e92cd6c09cad15ccbd22f223ee09a3b036f634c7d66f0a45574b85173"
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
