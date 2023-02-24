class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.7.6/psalm.phar"
  sha256 "c864a59d3a9ec114a6e7d434b5e7968ae6d6fadb1a6f17f1dc857361dac43fd5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a40fcfdf34b6a6d022a37e17424b61cfc8ab347ef1bb30cb530baa46bc08ce66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a40fcfdf34b6a6d022a37e17424b61cfc8ab347ef1bb30cb530baa46bc08ce66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a40fcfdf34b6a6d022a37e17424b61cfc8ab347ef1bb30cb530baa46bc08ce66"
    sha256 cellar: :any_skip_relocation, ventura:        "9f89e0130ce9f4593f30f58a4024551e158c19e09d6c09bebe6bffe09d306006"
    sha256 cellar: :any_skip_relocation, monterey:       "9f89e0130ce9f4593f30f58a4024551e158c19e09d6c09bebe6bffe09d306006"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f89e0130ce9f4593f30f58a4024551e158c19e09d6c09bebe6bffe09d306006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a40fcfdf34b6a6d022a37e17424b61cfc8ab347ef1bb30cb530baa46bc08ce66"
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
