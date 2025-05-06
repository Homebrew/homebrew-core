class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/6.10.3/psalm.phar"
  sha256 "117eed7f09f182065aa8612abe7b9502100fc528ce34d74d41d0dbfa2a735b30"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9856622515229e4b9b4d124aba8d5fa3a76f71affe4bc5105e6f6ce4375ffb1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9856622515229e4b9b4d124aba8d5fa3a76f71affe4bc5105e6f6ce4375ffb1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9856622515229e4b9b4d124aba8d5fa3a76f71affe4bc5105e6f6ce4375ffb1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c51da1e07bc807b1a43a77bf3ea7ed2b394a380b2f6185fcba44b8fdb235a049"
    sha256 cellar: :any_skip_relocation, ventura:       "c51da1e07bc807b1a43a77bf3ea7ed2b394a380b2f6185fcba44b8fdb235a049"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9856622515229e4b9b4d124aba8d5fa3a76f71affe4bc5105e6f6ce4375ffb1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9856622515229e4b9b4d124aba8d5fa3a76f71affe4bc5105e6f6ce4375ffb1e"
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
