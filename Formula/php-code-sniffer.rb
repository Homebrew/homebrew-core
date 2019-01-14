class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https://github.com/squizlabs/PHP_CodeSniffer/"
  url "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.4.0/phpcs.phar"
  sha256 "bc26904f539f17114183db3d5020cff0200f69d4866080d68a259bb31470dfb4"

  bottle :unneeded

  resource "phpcbf.phar" do
    url "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.4.0/phpcbf.phar"
    sha256 "e9a9f4ecf8d0c405f4d70f9738f07aa3bc60fbaa6dd68b524053d7f020d14c47"
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
