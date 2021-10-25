class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/4.11.1/psalm.phar"
  sha256 "2c54d841494db29c28f219c8d7e2b49feb1416c255165feaa04bd1462154d3f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ee9c56d4104ff8c8a9f4b91df46be3eb99799c9df0eac753bfbc4b7ec1fbabae"
    sha256 cellar: :any_skip_relocation, big_sur:       "89ff865d37136ab68cb886193c485f6987437f7e2dd6a79f9f1dba3a398ff49a"
    sha256 cellar: :any_skip_relocation, catalina:      "89ff865d37136ab68cb886193c485f6987437f7e2dd6a79f9f1dba3a398ff49a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee9c56d4104ff8c8a9f4b91df46be3eb99799c9df0eac753bfbc4b7ec1fbabae"
  end

  depends_on "composer" => :test

  uses_from_macos "php"

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
