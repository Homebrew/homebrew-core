class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/4.12.0/psalm.phar"
  sha256 "44d354b2291adf35d557760ee3a95992cfbe4ff966d0c87a5f94f7144a877ec2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9ce8f9314a5e446926c81a29dbd31c675d90a1679dbb43300b6e45047ba64e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9ce8f9314a5e446926c81a29dbd31c675d90a1679dbb43300b6e45047ba64e1"
    sha256 cellar: :any_skip_relocation, monterey:       "36cb968f965302e39ed05456c99bd32483c6aec887d18c3d16225b6d7d393e32"
    sha256 cellar: :any_skip_relocation, big_sur:        "36cb968f965302e39ed05456c99bd32483c6aec887d18c3d16225b6d7d393e32"
    sha256 cellar: :any_skip_relocation, catalina:       "36cb968f965302e39ed05456c99bd32483c6aec887d18c3d16225b6d7d393e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9ce8f9314a5e446926c81a29dbd31c675d90a1679dbb43300b6e45047ba64e1"
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
