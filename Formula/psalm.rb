class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/4.26.0/psalm.phar"
  sha256 "a4a80d4642e625f3d05641c68f6604fa98c28c0f15175617645526466e4fe048"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0818017a7ceddb3b777f10ec454b11834b3c8de5616cc076e8ae5d72b2afe39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0818017a7ceddb3b777f10ec454b11834b3c8de5616cc076e8ae5d72b2afe39"
    sha256 cellar: :any_skip_relocation, monterey:       "4afd007897a8d570691adc96d0846ef4c19a3849169c7c0a1f4def8046998019"
    sha256 cellar: :any_skip_relocation, big_sur:        "4afd007897a8d570691adc96d0846ef4c19a3849169c7c0a1f4def8046998019"
    sha256 cellar: :any_skip_relocation, catalina:       "4afd007897a8d570691adc96d0846ef4c19a3849169c7c0a1f4def8046998019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0818017a7ceddb3b777f10ec454b11834b3c8de5616cc076e8ae5d72b2afe39"
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
