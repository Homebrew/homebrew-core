class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.0.0/psalm.phar"
  sha256 "703251d223037557a4e1d86950554602a52d4ade0642b82cb0709a2fcbfc4076"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51bbfc0cdd3360c88cb6ec5a6761cda1a5ef00d628a73550c21bd4b42f25775f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51bbfc0cdd3360c88cb6ec5a6761cda1a5ef00d628a73550c21bd4b42f25775f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51bbfc0cdd3360c88cb6ec5a6761cda1a5ef00d628a73550c21bd4b42f25775f"
    sha256 cellar: :any_skip_relocation, monterey:       "b4f4423769402ae750bdb2652027e051b7b8221505fa48824a3da7d0a9d4c727"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4f4423769402ae750bdb2652027e051b7b8221505fa48824a3da7d0a9d4c727"
    sha256 cellar: :any_skip_relocation, catalina:       "b4f4423769402ae750bdb2652027e051b7b8221505fa48824a3da7d0a9d4c727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51bbfc0cdd3360c88cb6ec5a6761cda1a5ef00d628a73550c21bd4b42f25775f"
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
