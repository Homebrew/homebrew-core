class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.24.0/psalm.phar"
  sha256 "4a4bc2c953ffec1d53edaee781e23921b02345dd19f4e46b36652565c4aee57c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "746cfb40af0e10fdb7e7919678ddd6fb88b83abd65bda609359bfb8fda7821fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "746cfb40af0e10fdb7e7919678ddd6fb88b83abd65bda609359bfb8fda7821fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "746cfb40af0e10fdb7e7919678ddd6fb88b83abd65bda609359bfb8fda7821fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "730b25b4839674bb4b0263b2d00ffa227ed4dbef7b767dd2df01928c37cfcee0"
    sha256 cellar: :any_skip_relocation, ventura:        "730b25b4839674bb4b0263b2d00ffa227ed4dbef7b767dd2df01928c37cfcee0"
    sha256 cellar: :any_skip_relocation, monterey:       "730b25b4839674bb4b0263b2d00ffa227ed4dbef7b767dd2df01928c37cfcee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "746cfb40af0e10fdb7e7919678ddd6fb88b83abd65bda609359bfb8fda7821fc"
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
