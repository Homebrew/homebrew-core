class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/6.4.0/psalm.phar"
  sha256 "8a286c758082ed553fd3a00389f1134c08c8b664c9b8b56115c7f1aaa1a69906"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8318f18ae9c816b2361359b5aa5e809f43db1755f7277244cf2e3bbc0d784aae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8318f18ae9c816b2361359b5aa5e809f43db1755f7277244cf2e3bbc0d784aae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8318f18ae9c816b2361359b5aa5e809f43db1755f7277244cf2e3bbc0d784aae"
    sha256 cellar: :any_skip_relocation, sonoma:        "84b0f8b27a089293414a9a722dd94510c4d25f00ec4506fa2116571608a104a9"
    sha256 cellar: :any_skip_relocation, ventura:       "84b0f8b27a089293414a9a722dd94510c4d25f00ec4506fa2116571608a104a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8318f18ae9c816b2361359b5aa5e809f43db1755f7277244cf2e3bbc0d784aae"
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
