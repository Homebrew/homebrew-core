class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https://github.com/squizlabs/PHP_CodeSniffer/"
  url "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.7.1/phpcs.phar"
  sha256 "7a14323a14af9f58302d15442492ee1076a8cd72c018a816cb44965bf3a9b015"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "285090f8566a5e74896c54f657aa60f943c97a9c32492c166fdf58faee60c0b5"
  end

  depends_on "php"

  resource "phpcbf.phar" do
    url "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.7.1/phpcbf.phar"
    sha256 "c93c0e83cbda21c21f849ccf0f4b42979d20004a5a6172ed0ea270eca7ae6fa8"
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
