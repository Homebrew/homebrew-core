class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.6.0/psalm.phar"
  sha256 "07d0ccce44b19229a7a8bf00748e10700eee26043cd557262143022e97c3c405"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0862e80e3f45c61dc0c052c9b9ab4150c8a94f01a79932626d76843c68530dc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0862e80e3f45c61dc0c052c9b9ab4150c8a94f01a79932626d76843c68530dc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0862e80e3f45c61dc0c052c9b9ab4150c8a94f01a79932626d76843c68530dc3"
    sha256 cellar: :any_skip_relocation, ventura:        "bed8bdb9bfdf7346d832c2a4c628da81a0f7eff9a7c5f93748e577cdcc1ddaac"
    sha256 cellar: :any_skip_relocation, monterey:       "bed8bdb9bfdf7346d832c2a4c628da81a0f7eff9a7c5f93748e577cdcc1ddaac"
    sha256 cellar: :any_skip_relocation, big_sur:        "bed8bdb9bfdf7346d832c2a4c628da81a0f7eff9a7c5f93748e577cdcc1ddaac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0862e80e3f45c61dc0c052c9b9ab4150c8a94f01a79932626d76843c68530dc3"
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
