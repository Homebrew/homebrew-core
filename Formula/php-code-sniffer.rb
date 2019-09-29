class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https://github.com/squizlabs/PHP_CodeSniffer/"
  url "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.5.0/phpcs.phar"
  sha256 "ae59cacba481c09eaa48cb1fa02173efc6af7cdec5d472ca4677289385b30a1d"

  bottle :unneeded

  resource "phpcbf.phar" do
    url "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.5.0/phpcbf.phar"
    sha256 "d6fcbed855ea020af44fa9c775c8f15bab77bc10bc4534f00c5909c3f4c8c396"
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
