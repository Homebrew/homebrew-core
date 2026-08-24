class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https://github.com/PHPCSStandards/PHP_CodeSniffer"
  url "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/4.0.4/phpcs.phar"
  sha256 "4b010cd21d8bc8a17e2504792e3c77ef8259126f24caf7eafe7eddef1fa871e9"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a31c6cbe534d07e4f55743870286fff4374d73dee107f7d912e257a3cbdb1424"
  end

  depends_on "php"

  resource "phpcbf.phar" do
    url "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/4.0.4/phpcbf.phar"
    sha256 "0b3b8c5571543e94452f6edec0d7e924b287a64c13b73d8dcf3d25f0ee004948"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "phpcbf.phar resource needs to be updated" if version != resource("phpcbf.phar").version

    bin.install "phpcs.phar" => "phpcs"
    resource("phpcbf.phar").stage { bin.install "phpcbf.phar" => "phpcbf" }
  end

  test do
    (testpath/"test.php").write <<~PHP
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
    PHP

    assert_match "FOUND 1 ERROR", shell_output("#{bin}/phpcs --runtime-set ignore_errors_on_exit true test.php")
    assert_match "1 ERROR WERE FIXED", shell_output("#{bin}/phpcbf test.php")
    system bin/"phpcs", "test.php"
  end
end
