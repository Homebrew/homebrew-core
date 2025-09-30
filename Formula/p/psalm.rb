class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/6.13.1/psalm.phar"
  sha256 "6cec66e4b622403098d2153df7c5a79e9dbec78e2c89d7c27ff3aa950fb582f0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d2edb6efa8eb8f5a442f7a55cea422e8eec3d82f1ad5607348fc7ae7fa127a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d2edb6efa8eb8f5a442f7a55cea422e8eec3d82f1ad5607348fc7ae7fa127a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d2edb6efa8eb8f5a442f7a55cea422e8eec3d82f1ad5607348fc7ae7fa127a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d2edb6efa8eb8f5a442f7a55cea422e8eec3d82f1ad5607348fc7ae7fa127a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5495d1ef7d27eb79ee43824ec42c770003d9509185fd9e5985b27c697e21fb72"
    sha256 cellar: :any_skip_relocation, ventura:       "5495d1ef7d27eb79ee43824ec42c770003d9509185fd9e5985b27c697e21fb72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d2edb6efa8eb8f5a442f7a55cea422e8eec3d82f1ad5607348fc7ae7fa127a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d2edb6efa8eb8f5a442f7a55cea422e8eec3d82f1ad5607348fc7ae7fa127a5"
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
    libexec.install "psalm.phar" => "psalm"

    (bin/"psalm").write <<~EOS
      #!#{Formula["php"].opt_bin}/php
      <?php require '#{libexec}/psalm';
    EOS
  end

  test do
    (testpath/"composer.json").write <<~JSON
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
    JSON

    (testpath/"src/Email.php").write <<~PHP
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
    PHP

    system "composer", "install"

    assert_match "Config file created successfully. Please re-run psalm.",
                 shell_output("#{bin}/psalm --init")
    system bin/"psalm", "--no-progress"
  end
end
