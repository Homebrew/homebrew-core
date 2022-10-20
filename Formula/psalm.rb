class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/4.29.0/psalm.phar"
  sha256 "abe3a310f3403f04a3b676df0729db6c9cb7583213af4d5c8bc3bbe0130ed0e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0e14bc0a6c0fc49775aa450273ce1a76355b1efc317e71e8874b8963da77408"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0e14bc0a6c0fc49775aa450273ce1a76355b1efc317e71e8874b8963da77408"
    sha256 cellar: :any_skip_relocation, monterey:       "25a74ea91ab9389087083d0c3f659235e8cb22a8a84925d4d3e3ee1c23b8170d"
    sha256 cellar: :any_skip_relocation, big_sur:        "25a74ea91ab9389087083d0c3f659235e8cb22a8a84925d4d3e3ee1c23b8170d"
    sha256 cellar: :any_skip_relocation, catalina:       "25a74ea91ab9389087083d0c3f659235e8cb22a8a84925d4d3e3ee1c23b8170d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0e14bc0a6c0fc49775aa450273ce1a76355b1efc317e71e8874b8963da77408"
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
