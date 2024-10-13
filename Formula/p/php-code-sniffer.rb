class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https://github.com/PHPCSStandards/PHP_CodeSniffer"
  url "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/3.10.3/phpcs.phar"
  sha256 "763c61a526ba2e903878cb5060e7aa49ceba56fa652bd21bef0f48bd5e06a4b8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "95aaaf9e2d76b23190907aec3d52e3a6832e2ac898ee1a76534da5228f866b14"
  end

  depends_on "php"

  resource "phpcbf.phar" do
    url "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/3.10.3/phpcbf.phar"
    sha256 "e446161933b3710a91bcbb9ca6c3e2115b90abb6a34ce4faab7b50e4c931f059"
  end

  def install
    odie "phpcbf.phar resource needs to be updated" if version != resource("phpcbf.phar").version

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
    system bin/"phpcs", "test.php"
  end
end
