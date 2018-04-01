class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https://github.com/squizlabs/PHP_CodeSniffer/"
  url "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.2.3/phpcs.phar"
  sha256 "41ef9d09fca6be1dce5ee6b946a59461f4955245c3038c0ac17e0669caef6aa4"

  bottle :unneeded

  resource "phpcbf.phar" do
    url "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.2.3/phpcbf.phar"
    sha256 "34a94620615b674ef4ed44ab1648a9f1c874b35b4d48239e81a177a803a0e002"
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

    assert_match /FOUND 13 ERRORS/, shell_output("#{bin}/phpcs --runtime-set ignore_errors_on_exit true test.php")
    assert_match /13 ERRORS WERE FIXED/, shell_output("#{bin}/phpcbf test.php", 1)
    system "#{bin}/phpcs", "test.php"
  end
end
