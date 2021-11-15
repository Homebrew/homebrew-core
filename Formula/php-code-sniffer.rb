class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https://github.com/squizlabs/PHP_CodeSniffer/"
  url "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.6.1/phpcs.phar"
  sha256 "d0ce68aa469aff7e86935c6156a505c4d6dc90adcf2928d695d8331722ce706b"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "35f3e42c6aeea48da2001b2e2aeb17c2bd16b66d266afa8c56b01c0b96365280"
  end

  depends_on "php"

  resource "phpcbf.phar" do
    url "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.6.1/phpcbf.phar"
    sha256 "4fd260dd0eb4beadd6c68ae12a23e9adb15e155dfa787c9e6ba7104d3fc01471"
  end

  def install
    bin.install "phpcs.phar" => "phpcs"
    resource("phpcbf.phar").stage { bin.install "phpcbf.phar" => "phpcbf" }
  end

  test do
    (testpath/"test.php").write <<~EOS
      <?php
      /**
      * PHP version 5
      *
      * @category  Homebrew
      * @package   Homebrew_Test
      * @author    Homebrew <do.not@email.me>
      * @license   BSD Licence
      * @link      https://brew.sh/
      */
    EOS

    assert_match "FOUND 13 ERRORS", shell_output("#{bin}/phpcs --runtime-set ignore_errors_on_exit true test.php")
    assert_match "13 ERRORS WERE FIXED", shell_output("#{bin}/phpcbf test.php", 1)
    system "#{bin}/phpcs", "test.php"
  end
end
