class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/4.22.0/psalm.phar"
  sha256 "5ee3b40f210c0bdf9ef45471f0161ae4a74e61cdad42c51f589f00ca04bdcfac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53a28e96d19dcfafe8ff5f0792b48505417ce8ed3bc6d380bad812a0aa8f899a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53a28e96d19dcfafe8ff5f0792b48505417ce8ed3bc6d380bad812a0aa8f899a"
    sha256 cellar: :any_skip_relocation, monterey:       "1f9668569add0292a807ea1d60fc73df9a9c51bf853a95cadb875a0b58b52def"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f9668569add0292a807ea1d60fc73df9a9c51bf853a95cadb875a0b58b52def"
    sha256 cellar: :any_skip_relocation, catalina:       "1f9668569add0292a807ea1d60fc73df9a9c51bf853a95cadb875a0b58b52def"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53a28e96d19dcfafe8ff5f0792b48505417ce8ed3bc6d380bad812a0aa8f899a"
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
