class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/4.8.1/psalm.phar"
  sha256 "896246540c669c8d21e62e7c3865bc23cf1e7980caa920cd04b4e38a60354faf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eda9a66bdc4eceb127868bbdaf7a2b0fe9cea0226b7912f2be1149d91cc14179"
    sha256 cellar: :any_skip_relocation, big_sur:       "a54b71a894f31a2c1e5cae10fb0e394fcdc5f874c7d4ce6c66533a4a13605241"
    sha256 cellar: :any_skip_relocation, catalina:      "a54b71a894f31a2c1e5cae10fb0e394fcdc5f874c7d4ce6c66533a4a13605241"
    sha256 cellar: :any_skip_relocation, mojave:        "a54b71a894f31a2c1e5cae10fb0e394fcdc5f874c7d4ce6c66533a4a13605241"
  end

  depends_on "composer" => :test

  uses_from_macos "php"

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
