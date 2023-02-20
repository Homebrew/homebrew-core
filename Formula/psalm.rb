class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.7.1/psalm.phar"
  sha256 "1aade9da7a664d1dc0d1b7f15608e644791495a9b4813d3e60b7a935302e5657"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4378175fabad8554593a7ad1f5b5f942d86fe3922736930bc19d72cf23306fdf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4378175fabad8554593a7ad1f5b5f942d86fe3922736930bc19d72cf23306fdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4378175fabad8554593a7ad1f5b5f942d86fe3922736930bc19d72cf23306fdf"
    sha256 cellar: :any_skip_relocation, ventura:        "9169d2392e48fe5050da67f32ffbe429520c116769fe8c131eb7092c81563e12"
    sha256 cellar: :any_skip_relocation, monterey:       "9169d2392e48fe5050da67f32ffbe429520c116769fe8c131eb7092c81563e12"
    sha256 cellar: :any_skip_relocation, big_sur:        "9169d2392e48fe5050da67f32ffbe429520c116769fe8c131eb7092c81563e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4378175fabad8554593a7ad1f5b5f942d86fe3922736930bc19d72cf23306fdf"
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
