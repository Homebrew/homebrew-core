class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/7.22.1/psalm.phar"
  sha256 "89f395dcdfdc053e94a72219e8eaf0680f35cdd60af85253080854ddd0884c97"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "e06d82accd7450607acbca5ed0c0ece278067222d8df185a34e162e349c0b316"
    sha256 cellar: :any_skip_relocation, all: "2341497b10429a0348207dc6e640dfc1ada11ae2c70169b6d43cb70f5fcd179e"
  end

  depends_on "composer" => :test
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  allow_network_access! :test

  def install
    libexec.install "psalm.phar" => "psalm"

    (bin/"psalm").write <<~PHP
      #!#{formula_opt_bin("php")}/php
      <?php require '#{libexec}/psalm';
    PHP
  end

  test do
    require "rexml/document"

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

    (testpath/"src/main.php").write <<~PHP
      <?php
      require __DIR__ . '/../vendor/autoload.php';

      echo (string) \\Homebrew\\PsalmTest\\Email::fromString('brew@example.com');
    PHP

    system "composer", "install"

    system bin/"psalm", "--init"
    config = REXML::Document.new((testpath/"psalm.xml").read)
    assert_equal "src", config.root.elements["projectFiles/directory"].attributes["name"]
    system bin/"psalm", "--no-progress"
    assert_equal "brew@example.com", shell_output("php src/main.php")
  end
end
