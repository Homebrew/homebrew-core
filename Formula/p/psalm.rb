class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.16.0/psalm.phar"
  sha256 "45350f91f5b537f8bf34212136579a77599fda7eb58f86632859dd3583d9af5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "008070538c8e4e09f4bc97b6298b435a30e3e93224ff55b0f9fee5c6d7357bda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "008070538c8e4e09f4bc97b6298b435a30e3e93224ff55b0f9fee5c6d7357bda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "008070538c8e4e09f4bc97b6298b435a30e3e93224ff55b0f9fee5c6d7357bda"
    sha256 cellar: :any_skip_relocation, sonoma:         "04f3e3fe7e0b50df63cea333054129219abc3d47e2e39ef48c03557abc2bde58"
    sha256 cellar: :any_skip_relocation, ventura:        "04f3e3fe7e0b50df63cea333054129219abc3d47e2e39ef48c03557abc2bde58"
    sha256 cellar: :any_skip_relocation, monterey:       "04f3e3fe7e0b50df63cea333054129219abc3d47e2e39ef48c03557abc2bde58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "008070538c8e4e09f4bc97b6298b435a30e3e93224ff55b0f9fee5c6d7357bda"
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
