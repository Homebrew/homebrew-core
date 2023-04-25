class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.9.0/psalm.phar"
  sha256 "e7abcb4ffb7eddfe59c87d69166832e2fb5231070360b419205fe2224c1ddaf3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57618c0e79cbc27ce41023b5d67428116cd00c091d4f928fa81404743ccf8cd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57618c0e79cbc27ce41023b5d67428116cd00c091d4f928fa81404743ccf8cd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57618c0e79cbc27ce41023b5d67428116cd00c091d4f928fa81404743ccf8cd8"
    sha256 cellar: :any_skip_relocation, ventura:        "3523ce2dc31b564864689e34b3449e3fd7ba54d69062a1a278d7147a8e6720a3"
    sha256 cellar: :any_skip_relocation, monterey:       "3523ce2dc31b564864689e34b3449e3fd7ba54d69062a1a278d7147a8e6720a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3523ce2dc31b564864689e34b3449e3fd7ba54d69062a1a278d7147a8e6720a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57618c0e79cbc27ce41023b5d67428116cd00c091d4f928fa81404743ccf8cd8"
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
