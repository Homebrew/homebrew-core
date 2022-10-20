class Dtrx < Formula
  include Language::Python::Virtualenv

  desc "Intelligent archive extraction"
  homepage "https://pypi.org/project/dtrx/"
  url "https://files.pythonhosted.org/packages/ec/3c/e3b7669ac3821562221590611ec3285b736f538290328757e49986977a2b/dtrx-8.4.0.tar.gz"
  sha256 "e96b87194481a54807763b33fc764d4de5fe0e4df6ee51147f72c0ccb3bed6fa"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58301d1107aff067ca574e122a74a63c91d3594c86d22d36bd4367d6896415e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc18e47388c922f8b81e2da9bdaa51f70814455feafeeb04f5ca4c44d3dcf6c5"
    sha256 cellar: :any_skip_relocation, monterey:       "be9a3e3ff3042d4b3d4980281c66acdd8d0dad7c6b22c1e2a73f2af5f070e48e"
    sha256 cellar: :any_skip_relocation, big_sur:        "51460f14dccec8a306b86d1198807a7ec8741663c08e9214126ae3aeafca3a8c"
    sha256 cellar: :any_skip_relocation, catalina:       "4ab2fff1573252d25bd8db83bfb81a2b5288f36e5aecca2116c02e49c751d248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3bdfb2ca7e8415b114ab3e05e44d620d3010361cad80d17d6896af81a273dfc"
  end

  # Include a few common decompression handlers in addition to the python dep
  depends_on "p7zip"
  depends_on "python@3.10"
  depends_on "xz"
  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "unzip"

  def install
    virtualenv_install_with_resources
  end

  # Test a simple unzip. Sample taken from unzip formula
  test do
    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Hej!"

    system "zip", "test.zip", "test1", "test2", "test3"
    %w[test1 test2 test3].each do |f|
      rm f
      refute_predicate testpath/f, :exist?, "Text files should have been removed!"
    end

    system "#{bin}/dtrx", "--flat", "test.zip"

    %w[test1 test2 test3].each do |f|
      assert_predicate testpath/f, :exist?, "Failure unzipping test.zip!"
    end

    assert_equal "Hello!", (testpath/"test1").read
    assert_equal "Bonjour!", (testpath/"test2").read
    assert_equal "Hej!", (testpath/"test3").read
  end
end
