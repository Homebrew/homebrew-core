class Psalm < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://psalm.dev"
  url "https://github.com/vimeo/psalm/releases/download/7.10.0/psalm.phar"
  sha256 "282414bd6eb71c56fa754c0ba6c4c8014722a0a46849e04f803eaafcc9d5139a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eda376ab390a473bbe3caffd43a207e77f61676a10e7386cc0e331f7e46557d6"
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
