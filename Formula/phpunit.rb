class Phpunit < Formula
  desc "Programmer-oriented testing framework for PHP"
  homepage "https://phpunit.de"
  url "https://phar.phpunit.de/phpunit-10.0.7.phar"
  sha256 "0c63ad22fbf986db76a8ef60d9d436fcc08da44efd618b2cffaffd55e17399dc"
  license "BSD-3-Clause"

  livecheck do
    url "https://phar.phpunit.de/phpunit.phar"
    regex(%r{/phpunit[._-]v?(\d+(?:\.\d+)+)\.phar}i)
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78e7fb48a8b97e16df0c0761305977a0c89ca9d58fe10edec21f9a8b0f3758c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e39470876c3f8bd4c4644e7ca7ed89e6243195bdb69e332ed1f341c772330f7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "832e360d37037a47f86b3704054fe6e2e0463d876be707c27380385deaa501e7"
    sha256 cellar: :any_skip_relocation, ventura:        "6ab110bf087ed9c696acc9e89dd787dde397376d190d1bde48b2aa561dd19336"
    sha256 cellar: :any_skip_relocation, monterey:       "a0f7af9be827a9c5da3ab8c49aff1ec90f945320feca12169de816616703bc8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "145080b1ceeccd01eefc54f836f76f94d0d98ff7535b658159fcb025db2a0f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9187cbf9fe340611ad786a933b3232eab599368ab73e938426c736be4bad9cd3"
  end

  depends_on "php" => :test

  def install
    bin.install "phpunit-#{version}.phar" => "phpunit"
  end

  test do
    (testpath/"src/autoload.php").write <<~EOS
      <?php
      spl_autoload_register(
          function($class) {
              static $classes = null;
              if ($classes === null) {
                  $classes = array(
                      'email' => '/Email.php'
                  );
              }
              $cn = strtolower($class);
              if (isset($classes[$cn])) {
                  require __DIR__ . $classes[$cn];
              }
          },
          true,
          false
      );
    EOS

    (testpath/"src/Email.php").write <<~EOS
      <?php
        declare(strict_types=1);

        final class Email
        {
            private $email;

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
                    throw new InvalidArgumentException(
                        sprintf(
                            '"%s" is not a valid email address',
                            $email
                        )
                    );
                }
            }
        }
    EOS

    (testpath/"tests/EmailTest.php").write <<~EOS
      <?php
      declare(strict_types=1);

      use PHPUnit\\Framework\\TestCase;

      final class EmailTest extends TestCase
      {
          public function testCanBeCreatedFromValidEmailAddress(): void
          {
              $this->assertInstanceOf(
                  Email::class,
                  Email::fromString('user@example.com')
              );
          }

          public function testCannotBeCreatedFromInvalidEmailAddress(): void
          {
              $this->expectException(InvalidArgumentException::class);

              Email::fromString('invalid');
          }

          public function testCanBeUsedAsString(): void
          {
              $this->assertEquals(
                  'user@example.com',
                  Email::fromString('user@example.com')
              );
          }
      }

    EOS
    assert_match(/^OK \(3 tests, 3 assertions\)$/,
      shell_output("#{bin}/phpunit --bootstrap src/autoload.php tests/EmailTest.php"))
  end
end
