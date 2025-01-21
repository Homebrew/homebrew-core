class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  # Bump to php 8.4 on the next release, if possible.
  url "https://github.com/vimeo/psalm/releases/download/5.26.1/psalm.phar"
  sha256 "7d68a927dd72d30ec90e574cc114dd44851d9c49e3855e3c33c2bdd021259d1a"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "036217c9d7ae0e4dcf447575f0e44faffcc7ca84ece4376a4cd5f00628d95b8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "036217c9d7ae0e4dcf447575f0e44faffcc7ca84ece4376a4cd5f00628d95b8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "036217c9d7ae0e4dcf447575f0e44faffcc7ca84ece4376a4cd5f00628d95b8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "92d3874edda449c19be93b9936d84d863ca1e7dcca1aac98435ea393372ae30e"
    sha256 cellar: :any_skip_relocation, ventura:       "92d3874edda449c19be93b9936d84d863ca1e7dcca1aac98435ea393372ae30e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "036217c9d7ae0e4dcf447575f0e44faffcc7ca84ece4376a4cd5f00628d95b8a"
  end

  depends_on "composer" => :test
  depends_on "php@8.3"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    libexec.install "psalm.phar" => "psalm"

    (bin/"psalm").write <<~EOS
      #!#{Formula["php@8.3"].opt_bin}/php
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
