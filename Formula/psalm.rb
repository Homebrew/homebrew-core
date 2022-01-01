class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/4.17.0/psalm.phar"
  sha256 "e84dd7b06295ac45552f72eec27245b311ad38ed5ae5e72abc0f1d5a0ec7305d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98624a02299321d0894706dc9acacba8f04f368eebf416ebd6fea82667e76394"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98624a02299321d0894706dc9acacba8f04f368eebf416ebd6fea82667e76394"
    sha256 cellar: :any_skip_relocation, monterey:       "f213df454020d4e364c707eaed97b5893bd583053102c1dc00bc91c09889996e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f213df454020d4e364c707eaed97b5893bd583053102c1dc00bc91c09889996e"
    sha256 cellar: :any_skip_relocation, catalina:       "f213df454020d4e364c707eaed97b5893bd583053102c1dc00bc91c09889996e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98624a02299321d0894706dc9acacba8f04f368eebf416ebd6fea82667e76394"
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
