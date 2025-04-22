class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/6.10.1/psalm.phar"
  sha256 "fb5a8c3aff6793e055f35d8c9f739898b4887215e1ccf4ac7033497e8aec2c8e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf442e890379a1030cc7b14cc396a1969d6999bbd19da7d1278d12e630e34f43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf442e890379a1030cc7b14cc396a1969d6999bbd19da7d1278d12e630e34f43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf442e890379a1030cc7b14cc396a1969d6999bbd19da7d1278d12e630e34f43"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6be59962f9afba1a0ad6050ad44a26225654bb31a24471f6915a6d4b5989a9f"
    sha256 cellar: :any_skip_relocation, ventura:       "f6be59962f9afba1a0ad6050ad44a26225654bb31a24471f6915a6d4b5989a9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf442e890379a1030cc7b14cc396a1969d6999bbd19da7d1278d12e630e34f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf442e890379a1030cc7b14cc396a1969d6999bbd19da7d1278d12e630e34f43"
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
