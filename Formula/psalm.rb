class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/4.21.0/psalm.phar"
  sha256 "56c44162d854ca525c05f0cd3555d346ab47568d5c5af33ecf6268e88158fc82"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "802400a79d0a9ecfd3c89f488589b0b9bafd83aad8f4b30cefb0a8df28112b09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "802400a79d0a9ecfd3c89f488589b0b9bafd83aad8f4b30cefb0a8df28112b09"
    sha256 cellar: :any_skip_relocation, monterey:       "2d5b1cbd06b7fe09a00c258a2a358b8dd191fcca321fa71ebd82b4be98753850"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d5b1cbd06b7fe09a00c258a2a358b8dd191fcca321fa71ebd82b4be98753850"
    sha256 cellar: :any_skip_relocation, catalina:       "2d5b1cbd06b7fe09a00c258a2a358b8dd191fcca321fa71ebd82b4be98753850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "802400a79d0a9ecfd3c89f488589b0b9bafd83aad8f4b30cefb0a8df28112b09"
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
