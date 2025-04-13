class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/6.10.0/psalm.phar"
  sha256 "94dc6be0d722d9deb6eb364f765ee971522851120ad6150f96545e0c1f981012"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0ad9e25c0ff1d9ebad8d1de1a0a3cd5af04a915529f59685f60aeabfb82b158"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0ad9e25c0ff1d9ebad8d1de1a0a3cd5af04a915529f59685f60aeabfb82b158"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0ad9e25c0ff1d9ebad8d1de1a0a3cd5af04a915529f59685f60aeabfb82b158"
    sha256 cellar: :any_skip_relocation, sonoma:        "195c9f8c31719ddc48592db944bf219b3d2884bcb04ff04b01653453b90b916d"
    sha256 cellar: :any_skip_relocation, ventura:       "195c9f8c31719ddc48592db944bf219b3d2884bcb04ff04b01653453b90b916d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0ad9e25c0ff1d9ebad8d1de1a0a3cd5af04a915529f59685f60aeabfb82b158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0ad9e25c0ff1d9ebad8d1de1a0a3cd5af04a915529f59685f60aeabfb82b158"
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
