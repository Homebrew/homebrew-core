class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.7.7/psalm.phar"
  sha256 "2bcff374c9284fd1a18bb5d8728bebae9757a971c47c4295a40accc3d6e40b01"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40b94ca76c8d7f90998861a1c2cce22cb9862296d7427d4509406a907141f569"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40b94ca76c8d7f90998861a1c2cce22cb9862296d7427d4509406a907141f569"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40b94ca76c8d7f90998861a1c2cce22cb9862296d7427d4509406a907141f569"
    sha256 cellar: :any_skip_relocation, ventura:        "d43129d6fcf14f4058870501e78df89ed65f4b440bfc7b4b13d6bfa9552d5617"
    sha256 cellar: :any_skip_relocation, monterey:       "d43129d6fcf14f4058870501e78df89ed65f4b440bfc7b4b13d6bfa9552d5617"
    sha256 cellar: :any_skip_relocation, big_sur:        "d43129d6fcf14f4058870501e78df89ed65f4b440bfc7b4b13d6bfa9552d5617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40b94ca76c8d7f90998861a1c2cce22cb9862296d7427d4509406a907141f569"
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
