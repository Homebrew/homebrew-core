class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.22.1/psalm.phar"
  sha256 "489e2e5271d7de582c1161dc639e3133acde733164a9b1a84f9fd7fdbc3216c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f0f943161f63941eb2e717bbe4e7fded98003f499d4cdb77d454a1da33671f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f0f943161f63941eb2e717bbe4e7fded98003f499d4cdb77d454a1da33671f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f0f943161f63941eb2e717bbe4e7fded98003f499d4cdb77d454a1da33671f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "efdb42b0410dcfbcd01eb35e9b2e4a37fd0e355292bdae67afe56a9aa436d145"
    sha256 cellar: :any_skip_relocation, ventura:        "efdb42b0410dcfbcd01eb35e9b2e4a37fd0e355292bdae67afe56a9aa436d145"
    sha256 cellar: :any_skip_relocation, monterey:       "efdb42b0410dcfbcd01eb35e9b2e4a37fd0e355292bdae67afe56a9aa436d145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f0f943161f63941eb2e717bbe4e7fded98003f499d4cdb77d454a1da33671f7"
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
