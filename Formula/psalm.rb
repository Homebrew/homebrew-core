class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.7.0/psalm.phar"
  sha256 "3ba145c4674faac1b28a64dc382ea26f113c9c9513c70ae276044b853d9728e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c96cf8384f9c0085e1cc6e0ed67d31e0fe061bf06f6acdf6c7e3c93ea1341e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c96cf8384f9c0085e1cc6e0ed67d31e0fe061bf06f6acdf6c7e3c93ea1341e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c96cf8384f9c0085e1cc6e0ed67d31e0fe061bf06f6acdf6c7e3c93ea1341e1"
    sha256 cellar: :any_skip_relocation, ventura:        "ca43b7e16465f87bf546f73584013232d49604dda674cbf2002cb8f7cbf4e1e0"
    sha256 cellar: :any_skip_relocation, monterey:       "ca43b7e16465f87bf546f73584013232d49604dda674cbf2002cb8f7cbf4e1e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca43b7e16465f87bf546f73584013232d49604dda674cbf2002cb8f7cbf4e1e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c96cf8384f9c0085e1cc6e0ed67d31e0fe061bf06f6acdf6c7e3c93ea1341e1"
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
