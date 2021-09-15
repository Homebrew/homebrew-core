class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/4.10.0/psalm.phar"
  sha256 "fa661e7076264d691b238fc740a238889742258b05f90e0bec5ba2d3483dc2fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b23cc57995e0c37ac52168602a23c8ecc9513f958b47bd8c119b68ec5493a853"
    sha256 cellar: :any_skip_relocation, big_sur:       "09f3f07b25eaa9247044e4b4f5372772e89434e76fc299601abcf5badac382ce"
    sha256 cellar: :any_skip_relocation, catalina:      "09f3f07b25eaa9247044e4b4f5372772e89434e76fc299601abcf5badac382ce"
    sha256 cellar: :any_skip_relocation, mojave:        "09f3f07b25eaa9247044e4b4f5372772e89434e76fc299601abcf5badac382ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b23cc57995e0c37ac52168602a23c8ecc9513f958b47bd8c119b68ec5493a853"
  end

  depends_on "composer" => :test

  uses_from_macos "php"

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
