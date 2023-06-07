class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.12.0/psalm.phar"
  sha256 "6a305c9df0bd6fed146239671e10fb2f67bd5b75d3ad3f594b523648d167f8c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cb9050f5a626176f38d08a4ab1b524ec1257330aa19fff5ebfcfc8f413ac8ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cb9050f5a626176f38d08a4ab1b524ec1257330aa19fff5ebfcfc8f413ac8ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cb9050f5a626176f38d08a4ab1b524ec1257330aa19fff5ebfcfc8f413ac8ff"
    sha256 cellar: :any_skip_relocation, ventura:        "1f2c2ac6d5593f12eb0e579696ad945392ba6473fee1da48dce767cbdc01f0e7"
    sha256 cellar: :any_skip_relocation, monterey:       "1f2c2ac6d5593f12eb0e579696ad945392ba6473fee1da48dce767cbdc01f0e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f2c2ac6d5593f12eb0e579696ad945392ba6473fee1da48dce767cbdc01f0e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cb9050f5a626176f38d08a4ab1b524ec1257330aa19fff5ebfcfc8f413ac8ff"
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
