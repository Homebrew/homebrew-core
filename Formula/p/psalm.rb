class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.22.0/psalm.phar"
  sha256 "735eacf4360d8105c1a823cc3aa3259c5699783da45f6206531b6f5a67b125ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5bade2c856ece203bf24d14f9d3f53f447d463696d30d70bd57a7ca26f38add"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5bade2c856ece203bf24d14f9d3f53f447d463696d30d70bd57a7ca26f38add"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5bade2c856ece203bf24d14f9d3f53f447d463696d30d70bd57a7ca26f38add"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e4d8c6efc5f1b46bf129cfa74e48fa931f83036b2d894b95fb9b820415c732a"
    sha256 cellar: :any_skip_relocation, ventura:        "9e4d8c6efc5f1b46bf129cfa74e48fa931f83036b2d894b95fb9b820415c732a"
    sha256 cellar: :any_skip_relocation, monterey:       "9e4d8c6efc5f1b46bf129cfa74e48fa931f83036b2d894b95fb9b820415c732a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5bade2c856ece203bf24d14f9d3f53f447d463696d30d70bd57a7ca26f38add"
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
