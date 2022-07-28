class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/v4.25.0/psalm.phar"
  sha256 "6c4bfd63307270df9fb370de014fd0a6e3afb265052e0ae5b4611ed8ab943347"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21ab927df8b98fbfc9f37c160c8a7a62740d422aeb04d45710e40c00ca084bf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21ab927df8b98fbfc9f37c160c8a7a62740d422aeb04d45710e40c00ca084bf6"
    sha256 cellar: :any_skip_relocation, monterey:       "aeb509abf26566ef661c00949bfff2292b50d05838f5233ed5542333a7a79bc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "aeb509abf26566ef661c00949bfff2292b50d05838f5233ed5542333a7a79bc2"
    sha256 cellar: :any_skip_relocation, catalina:       "aeb509abf26566ef661c00949bfff2292b50d05838f5233ed5542333a7a79bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21ab927df8b98fbfc9f37c160c8a7a62740d422aeb04d45710e40c00ca084bf6"
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
