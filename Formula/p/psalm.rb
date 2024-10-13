class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/5.26.1/psalm.phar"
  sha256 "7d68a927dd72d30ec90e574cc114dd44851d9c49e3855e3c33c2bdd021259d1a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7668d9744c37551061d79c812116ad92fee0aac3fc323abda1e71f62cde39848"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7668d9744c37551061d79c812116ad92fee0aac3fc323abda1e71f62cde39848"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7668d9744c37551061d79c812116ad92fee0aac3fc323abda1e71f62cde39848"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7668d9744c37551061d79c812116ad92fee0aac3fc323abda1e71f62cde39848"
    sha256 cellar: :any_skip_relocation, sonoma:         "c91062726d01714fb820072608162c8a5caa2af88c147b548652956d0a5b3cee"
    sha256 cellar: :any_skip_relocation, ventura:        "c91062726d01714fb820072608162c8a5caa2af88c147b548652956d0a5b3cee"
    sha256 cellar: :any_skip_relocation, monterey:       "c91062726d01714fb820072608162c8a5caa2af88c147b548652956d0a5b3cee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7668d9744c37551061d79c812116ad92fee0aac3fc323abda1e71f62cde39848"
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
