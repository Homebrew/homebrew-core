class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/4.27.0/psalm.phar"
  sha256 "f9e9ead5c504108f4424d8d5216a5f4fb8d0bf79935d3b19b59c1fba2f5f2639"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0926475edffb8f413c1d59d28abef504fe639c94521f26f66977fd098a07147e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0926475edffb8f413c1d59d28abef504fe639c94521f26f66977fd098a07147e"
    sha256 cellar: :any_skip_relocation, monterey:       "4398112f8e164fb944b44dfdd539df2177ce21103dc58982a4defc42f6a72221"
    sha256 cellar: :any_skip_relocation, big_sur:        "4398112f8e164fb944b44dfdd539df2177ce21103dc58982a4defc42f6a72221"
    sha256 cellar: :any_skip_relocation, catalina:       "4398112f8e164fb944b44dfdd539df2177ce21103dc58982a4defc42f6a72221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0926475edffb8f413c1d59d28abef504fe639c94521f26f66977fd098a07147e"
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
