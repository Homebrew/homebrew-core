class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/v4.15.0/psalm.phar"
  sha256 "8ef50d9c0e4e4e6c378753b552bee95288e0539211830ab653f245fc1c8ed040"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95547b03b9f8caa0db6cef44f685b96abc1a343bb8cba21003c37d95bb8e8e5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95547b03b9f8caa0db6cef44f685b96abc1a343bb8cba21003c37d95bb8e8e5b"
    sha256 cellar: :any_skip_relocation, monterey:       "7318e73bb4747090806adf6e232a0a46e9814881962713ca4b04e66472b6f34d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7318e73bb4747090806adf6e232a0a46e9814881962713ca4b04e66472b6f34d"
    sha256 cellar: :any_skip_relocation, catalina:       "7318e73bb4747090806adf6e232a0a46e9814881962713ca4b04e66472b6f34d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95547b03b9f8caa0db6cef44f685b96abc1a343bb8cba21003c37d95bb8e8e5b"
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
