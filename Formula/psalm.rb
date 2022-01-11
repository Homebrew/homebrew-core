class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/4.18.1/psalm.phar"
  sha256 "5e97cdbb11fb1e87fe1a37a77af5a2406993253c18ee91972769763bae0fcd97"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c94185b0cd0f25b64b419bbbea2dfa3f3cdccb14659f345c7de508ad24f8fc33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c94185b0cd0f25b64b419bbbea2dfa3f3cdccb14659f345c7de508ad24f8fc33"
    sha256 cellar: :any_skip_relocation, monterey:       "fb9351ba89edbe0bb5138b7fc2642b92d71d44d0e15faa037c2336fcdc512146"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb9351ba89edbe0bb5138b7fc2642b92d71d44d0e15faa037c2336fcdc512146"
    sha256 cellar: :any_skip_relocation, catalina:       "fb9351ba89edbe0bb5138b7fc2642b92d71d44d0e15faa037c2336fcdc512146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c94185b0cd0f25b64b419bbbea2dfa3f3cdccb14659f345c7de508ad24f8fc33"
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
