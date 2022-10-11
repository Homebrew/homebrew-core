class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/4.29.0/psalm.phar"
  sha256 "abe3a310f3403f04a3b676df0729db6c9cb7583213af4d5c8bc3bbe0130ed0e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5429aedfb35fc1679b261200ba395fa6ae47cdb7b49c72520c09133ec00ebe90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5429aedfb35fc1679b261200ba395fa6ae47cdb7b49c72520c09133ec00ebe90"
    sha256 cellar: :any_skip_relocation, monterey:       "698619ee2ae9b1f88e7d082b0bfdca2d36d9ac9db3de65677bedaf19b2ddd745"
    sha256 cellar: :any_skip_relocation, big_sur:        "698619ee2ae9b1f88e7d082b0bfdca2d36d9ac9db3de65677bedaf19b2ddd745"
    sha256 cellar: :any_skip_relocation, catalina:       "698619ee2ae9b1f88e7d082b0bfdca2d36d9ac9db3de65677bedaf19b2ddd745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5429aedfb35fc1679b261200ba395fa6ae47cdb7b49c72520c09133ec00ebe90"
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
