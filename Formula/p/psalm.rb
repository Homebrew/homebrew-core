class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.18.0/psalm.phar"
  sha256 "1372b723692256b6995ffe14da4ecf708df85913fd4c206c24c8ab8b1a96552a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91fd995815c0e3e289ce65aacc47121298a5a47bfd741a93f6c878f8ca1c1100"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91fd995815c0e3e289ce65aacc47121298a5a47bfd741a93f6c878f8ca1c1100"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91fd995815c0e3e289ce65aacc47121298a5a47bfd741a93f6c878f8ca1c1100"
    sha256 cellar: :any_skip_relocation, sonoma:         "02da1f9f2f43a73b2d7ff94caf67ac52030b2953a1a4fa988fa255dbb01f8f66"
    sha256 cellar: :any_skip_relocation, ventura:        "02da1f9f2f43a73b2d7ff94caf67ac52030b2953a1a4fa988fa255dbb01f8f66"
    sha256 cellar: :any_skip_relocation, monterey:       "02da1f9f2f43a73b2d7ff94caf67ac52030b2953a1a4fa988fa255dbb01f8f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91fd995815c0e3e289ce65aacc47121298a5a47bfd741a93f6c878f8ca1c1100"
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
