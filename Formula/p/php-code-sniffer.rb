class PhpCodeSniffer < Formula
  desc "Check coding standards in PHP, JavaScript and CSS"
  homepage "https://github.com/PHPCSStandards/PHP_CodeSniffer"
  url "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/3.10.2/phpcs.phar"
  sha256 "5f580b08328af20a4138a6dcefdbb4c3307e133d9dfbabdf925c08c7d87f18de"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8012777af1c70a7863b9b9279fae023afa537edde3ea24d7f226d18d6180b78a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8012777af1c70a7863b9b9279fae023afa537edde3ea24d7f226d18d6180b78a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8012777af1c70a7863b9b9279fae023afa537edde3ea24d7f226d18d6180b78a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8012777af1c70a7863b9b9279fae023afa537edde3ea24d7f226d18d6180b78a"
    sha256 cellar: :any_skip_relocation, ventura:        "8012777af1c70a7863b9b9279fae023afa537edde3ea24d7f226d18d6180b78a"
    sha256 cellar: :any_skip_relocation, monterey:       "8012777af1c70a7863b9b9279fae023afa537edde3ea24d7f226d18d6180b78a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d4b530645e477fb65bbde35448292c3dc1606a8d8ce04c99717412c71f23fac"
  end

  depends_on "php"

  resource "phpcbf.phar" do
    url "https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/download/3.10.2/phpcbf.phar"
    sha256 "7b4b1316ce388600c2a052b41b9badd2d906827f0a08a08873ca5d1063dd1038"
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
