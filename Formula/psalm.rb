class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/4.16.1/psalm.phar"
  sha256 "fb315861ce8b2e3bc4d936014216fe87524e7c22b1cccfa4ab9fb8727fcf5933"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0f9b20db129536fc8acd19062adaa769a029cfec95bdd7b395082c8158805ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0f9b20db129536fc8acd19062adaa769a029cfec95bdd7b395082c8158805ac"
    sha256 cellar: :any_skip_relocation, monterey:       "a1f1a56cfcc598d68fa54d252823c0d2d82921538e76e2512c33e72e96d5aef2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1f1a56cfcc598d68fa54d252823c0d2d82921538e76e2512c33e72e96d5aef2"
    sha256 cellar: :any_skip_relocation, catalina:       "a1f1a56cfcc598d68fa54d252823c0d2d82921538e76e2512c33e72e96d5aef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0f9b20db129536fc8acd19062adaa769a029cfec95bdd7b395082c8158805ac"
  end

  depends_on "composer" => :test
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
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
