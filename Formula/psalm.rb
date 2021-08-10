class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/4.9.2/psalm.phar"
  sha256 "71d704c3306488784b39241752535d90a4e1487d8b3efa347aee7dddd5397a9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5d0adee30ee864ba7dab89c8b8a29730f0c4732b6ea5c916cdefa1c180833333"
    sha256 cellar: :any_skip_relocation, big_sur:       "d8e9fc759e0f453699ddd45d9487799930e1f1e4fe4d2aa46bd75c1b00e15d77"
    sha256 cellar: :any_skip_relocation, catalina:      "d8e9fc759e0f453699ddd45d9487799930e1f1e4fe4d2aa46bd75c1b00e15d77"
    sha256 cellar: :any_skip_relocation, mojave:        "d8e9fc759e0f453699ddd45d9487799930e1f1e4fe4d2aa46bd75c1b00e15d77"
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
