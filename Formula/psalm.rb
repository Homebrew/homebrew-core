class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/4.13.1/psalm.phar"
  sha256 "7605fae9a6e1b9ffa6e88ad077cec56a19454e5ec1a7192f387ce76472dd73b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ec28ebeec34b64ce80b5478d26d9cf67484257c50af3f9001b3d663de84a3ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ec28ebeec34b64ce80b5478d26d9cf67484257c50af3f9001b3d663de84a3ef"
    sha256 cellar: :any_skip_relocation, monterey:       "681f1f612f89d2eab1f60d733ed6dc956bb7b8d9dde894b8caded609f96b4764"
    sha256 cellar: :any_skip_relocation, big_sur:        "681f1f612f89d2eab1f60d733ed6dc956bb7b8d9dde894b8caded609f96b4764"
    sha256 cellar: :any_skip_relocation, catalina:       "681f1f612f89d2eab1f60d733ed6dc956bb7b8d9dde894b8caded609f96b4764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ec28ebeec34b64ce80b5478d26d9cf67484257c50af3f9001b3d663de84a3ef"
  end

  depends_on "composer" => :test
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
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
          "php": ">=7.1.3"
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
    assert_match "No errors found!",
                 shell_output("#{bin}/psalm")
  end
end
