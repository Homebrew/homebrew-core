class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.8.0/psalm.phar"
  sha256 "02e84304beccd27d3ff67e9f61e8d9d550b53a9446a6cb21778552fc8c6c21db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0dd4415b852350f882d3908580dabf59bb872284a10eee7ab03389c7b19960aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dd4415b852350f882d3908580dabf59bb872284a10eee7ab03389c7b19960aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0dd4415b852350f882d3908580dabf59bb872284a10eee7ab03389c7b19960aa"
    sha256 cellar: :any_skip_relocation, ventura:        "3fd4e1b2843e3f18ea75d288abc32d1876727bc767231c43c65dd1758bcd2ff5"
    sha256 cellar: :any_skip_relocation, monterey:       "3fd4e1b2843e3f18ea75d288abc32d1876727bc767231c43c65dd1758bcd2ff5"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fd4e1b2843e3f18ea75d288abc32d1876727bc767231c43c65dd1758bcd2ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dd4415b852350f882d3908580dabf59bb872284a10eee7ab03389c7b19960aa"
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
