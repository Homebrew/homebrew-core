class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/6.12.0/psalm.phar"
  sha256 "8e8846f3a5ed8c39ae17da6dea2e178bfbee642cc5e7bf674399afcd68c6fddb"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a392046edf7cf7eeb814bd52c73070494458548d1b21895c3bfd08759e02125"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a392046edf7cf7eeb814bd52c73070494458548d1b21895c3bfd08759e02125"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a392046edf7cf7eeb814bd52c73070494458548d1b21895c3bfd08759e02125"
    sha256 cellar: :any_skip_relocation, sonoma:        "345919daa60e237e859f577b92fb1846236463c118861b382565da6e6fc5c368"
    sha256 cellar: :any_skip_relocation, ventura:       "345919daa60e237e859f577b92fb1846236463c118861b382565da6e6fc5c368"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a392046edf7cf7eeb814bd52c73070494458548d1b21895c3bfd08759e02125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a392046edf7cf7eeb814bd52c73070494458548d1b21895c3bfd08759e02125"
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
