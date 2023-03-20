class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.8.0/psalm.phar"
  sha256 "02e84304beccd27d3ff67e9f61e8d9d550b53a9446a6cb21778552fc8c6c21db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "466065fc9c7d63118f6c8ff9d2b8e21445d79654f7ba140e79c19b88d3d5f441"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "466065fc9c7d63118f6c8ff9d2b8e21445d79654f7ba140e79c19b88d3d5f441"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "466065fc9c7d63118f6c8ff9d2b8e21445d79654f7ba140e79c19b88d3d5f441"
    sha256 cellar: :any_skip_relocation, ventura:        "7cdc98038ceaaf31c2ffdbc99241824dec52fa0f986c4aa5429d79ab92f6e0c9"
    sha256 cellar: :any_skip_relocation, monterey:       "7cdc98038ceaaf31c2ffdbc99241824dec52fa0f986c4aa5429d79ab92f6e0c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cdc98038ceaaf31c2ffdbc99241824dec52fa0f986c4aa5429d79ab92f6e0c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "466065fc9c7d63118f6c8ff9d2b8e21445d79654f7ba140e79c19b88d3d5f441"
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
