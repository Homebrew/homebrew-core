class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/6.13.0/psalm.phar"
  sha256 "5c39a7782450f889c8c2a60cd4942d70939df9ae703f4c0a19d60823159f08e7"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dac4b95687bf8973e21b5e9c57014def99b69f4f3722300630c2547d688c1290"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dac4b95687bf8973e21b5e9c57014def99b69f4f3722300630c2547d688c1290"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dac4b95687bf8973e21b5e9c57014def99b69f4f3722300630c2547d688c1290"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b5439a1081af205c9eee6365186d01455059cf123b85095e238c41332e30cb1"
    sha256 cellar: :any_skip_relocation, ventura:       "1b5439a1081af205c9eee6365186d01455059cf123b85095e238c41332e30cb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dac4b95687bf8973e21b5e9c57014def99b69f4f3722300630c2547d688c1290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dac4b95687bf8973e21b5e9c57014def99b69f4f3722300630c2547d688c1290"
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
