class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/v4.14.0/psalm.phar"
  sha256 "4dfbab07d927486ae525e117ffb3c3983c606153d461552a02139b28f859ce89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b89b1dc38a7137dda873dfd7d0bd398b709eb6f373e8bc2f5c0cf8abeaada8d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b89b1dc38a7137dda873dfd7d0bd398b709eb6f373e8bc2f5c0cf8abeaada8d9"
    sha256 cellar: :any_skip_relocation, monterey:       "59e0d0e54b9c73e3528ab447541deed14879b65c65e46ab145b37955bb5d6b85"
    sha256 cellar: :any_skip_relocation, big_sur:        "59e0d0e54b9c73e3528ab447541deed14879b65c65e46ab145b37955bb5d6b85"
    sha256 cellar: :any_skip_relocation, catalina:       "59e0d0e54b9c73e3528ab447541deed14879b65c65e46ab145b37955bb5d6b85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b89b1dc38a7137dda873dfd7d0bd398b709eb6f373e8bc2f5c0cf8abeaada8d9"
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
