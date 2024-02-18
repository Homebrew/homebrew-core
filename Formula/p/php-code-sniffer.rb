class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https://github.com/PHPCSStandards/PHP_CodeSniffer"
  url "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/3.9.0/phpcs.phar"
  sha256 "0112bd965eb80fe14172271dca6f1cdebef8f4a98bdf59bd013cde241facd38c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "af3c82aaf708206a849854deb336a2fbf848767006deb887acc8560ead328e48"
  end

  depends_on "php"

  resource "phpcbf.phar" do
    url "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/3.9.0/phpcbf.phar"
    sha256 "870a85742cc260d6e80ccd69e435fe7543d7d31cd278ad54b90ec28e756db12a"
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
