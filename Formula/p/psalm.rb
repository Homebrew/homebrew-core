class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.23.1/psalm.phar"
  sha256 "a244e6f9cf4879e4bd262879e69f443e6642e29f511a4b7d586fe0ca864173e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04a90b5610feed8f943fc18c701b65bf135d2dd4319f3fa830bb719efb2bf383"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04a90b5610feed8f943fc18c701b65bf135d2dd4319f3fa830bb719efb2bf383"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04a90b5610feed8f943fc18c701b65bf135d2dd4319f3fa830bb719efb2bf383"
    sha256 cellar: :any_skip_relocation, sonoma:         "a641bae14816de0122ab31f8abcae3d18d39166a7e708aacb8e5336299166ba6"
    sha256 cellar: :any_skip_relocation, ventura:        "a641bae14816de0122ab31f8abcae3d18d39166a7e708aacb8e5336299166ba6"
    sha256 cellar: :any_skip_relocation, monterey:       "a641bae14816de0122ab31f8abcae3d18d39166a7e708aacb8e5336299166ba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04a90b5610feed8f943fc18c701b65bf135d2dd4319f3fa830bb719efb2bf383"
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
