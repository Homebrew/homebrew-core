class Phpunit < Formula
  desc "Programmer-oriented testing framework for PHP"
  homepage "https://phpunit.de"
  url "https://phar.phpunit.de/phpunit-10.0.8.phar"
  sha256 "f7df7070895c329e2aecf45366c5cf75ecf0eba8615b2169294efbee4299ee30"
  license "BSD-3-Clause"

  livecheck do
    url "https://phar.phpunit.de/phpunit.phar"
    regex(%r{/phpunit[._-]v?(\d+(?:\.\d+)+)\.phar}i)
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d86be673503ae3b6b15ccc59be5ea1c37ac0f83133733b9f3fd9635bfc36ef3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08e1a104ce0ca2075d972f87a62409322dfa2ad1bdca95eb5d21db119c91ce54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "889540c2529a7cfa822be0ff21b2db4e6ca895b50354d4be426a37ffb36e20d5"
    sha256 cellar: :any_skip_relocation, ventura:        "fff5afe9c00aa320d32544223d9af42df27709856e7b299c07462de444f11d09"
    sha256 cellar: :any_skip_relocation, monterey:       "b1d5a5fb6d5cc879ddfb6346ef58d80aac7a2c2549394299abcf31319f7eaf87"
    sha256 cellar: :any_skip_relocation, big_sur:        "7453d61118868929aef7995933324300981ba629ae0afc5d5f261ba95fb330f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75767dd27df8aa73793c7a06886dce77f4a34e244ea80140ac2de7ec43546696"
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
