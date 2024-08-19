class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.25.0/psalm.phar"
  sha256 "c914089a0a93e63e30365b6263b442f1abb0842896ce68267adc566fba6a4d6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c633e0ce3bcecd7b7f17a0fd797b8a2001e8a754b80a1162e347a3e970c7eebf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c633e0ce3bcecd7b7f17a0fd797b8a2001e8a754b80a1162e347a3e970c7eebf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c633e0ce3bcecd7b7f17a0fd797b8a2001e8a754b80a1162e347a3e970c7eebf"
    sha256 cellar: :any_skip_relocation, sonoma:         "4efa33533fdf9ee99b160c971732b8e1d79bd9598f3eb220e0468878bf3a51b9"
    sha256 cellar: :any_skip_relocation, ventura:        "4efa33533fdf9ee99b160c971732b8e1d79bd9598f3eb220e0468878bf3a51b9"
    sha256 cellar: :any_skip_relocation, monterey:       "4efa33533fdf9ee99b160c971732b8e1d79bd9598f3eb220e0468878bf3a51b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c08515655e03c77d6bf27afac93978f01ceb9ecb105045e62204a303e298f37"
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
          "php": ">=8.1"
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

        /**
        * @psalm-suppress PossiblyUnusedMethod
        */
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
    system bin/"psalm", "--no-progress"
  end
end
