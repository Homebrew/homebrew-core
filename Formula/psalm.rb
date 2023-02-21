class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.7.3/psalm.phar"
  sha256 "b3d2449e01eaff1ffd99de998323497f1afad2d9011bcc5b83e7950549ea623f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "051eda61b524e046b8dd36c30d3cec8337a348bb7114f2cc10b1ae66304d7798"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "051eda61b524e046b8dd36c30d3cec8337a348bb7114f2cc10b1ae66304d7798"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "051eda61b524e046b8dd36c30d3cec8337a348bb7114f2cc10b1ae66304d7798"
    sha256 cellar: :any_skip_relocation, ventura:        "5fd2992ccae0e85bb02c5b9bb466337d4141a6c8551b10393917ff25cea26ece"
    sha256 cellar: :any_skip_relocation, monterey:       "5fd2992ccae0e85bb02c5b9bb466337d4141a6c8551b10393917ff25cea26ece"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fd2992ccae0e85bb02c5b9bb466337d4141a6c8551b10393917ff25cea26ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "051eda61b524e046b8dd36c30d3cec8337a348bb7114f2cc10b1ae66304d7798"
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
