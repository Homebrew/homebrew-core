class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https://github.com/squizlabs/PHP_CodeSniffer/"
  url "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.5.3/phpcs.phar"
  sha256 "b44e0ad96138e2697a97959fefb9c6f1491f4a22d5daf08aabed12e9a2869678"

  bottle :unneeded

  resource "phpcbf.phar" do
    url "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.5.3/phpcbf.phar"
    sha256 "db20ec9cfd434deba03f6f20c818732d477696589d5aea3df697986b6e723ad7"
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
