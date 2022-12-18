class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.3.0/psalm.phar"
  sha256 "03d7fb6321eeeeb16cb67e8177cac253d1d66ab828bf1d3c2b4da2f70379df81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ea235a79fed84a5bf2d3c27b73ee4bd1adf35605a4397ae3ffc05f088da60fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ea235a79fed84a5bf2d3c27b73ee4bd1adf35605a4397ae3ffc05f088da60fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ea235a79fed84a5bf2d3c27b73ee4bd1adf35605a4397ae3ffc05f088da60fc"
    sha256 cellar: :any_skip_relocation, ventura:        "afe95b32fe7b3d1b13f0ff62fccbd2718b6ec6f554724c49d051722c89a255c4"
    sha256 cellar: :any_skip_relocation, monterey:       "afe95b32fe7b3d1b13f0ff62fccbd2718b6ec6f554724c49d051722c89a255c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "afe95b32fe7b3d1b13f0ff62fccbd2718b6ec6f554724c49d051722c89a255c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ea235a79fed84a5bf2d3c27b73ee4bd1adf35605a4397ae3ffc05f088da60fc"
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
