class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/4f/dc/dca6822522902b922f1ebce3f1dfc696400470fd410821d0877f50733aa7/Glances-3.3.0.2.tar.gz"
  sha256 "d830e1b71dbf098cc345d1a932d3104a472118ab46312b679612f5e81cbcb564"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "393aee45cd1d274d57a1d83a076f52227f3ada311776eae504f1a1646a5d543d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0474f9000b426e63dd94db670aae312591a777572c52827b039f59454d8d4734"
    sha256 cellar: :any_skip_relocation, monterey:       "f871634fa6542a6503d39881521eb66a4306ef5697a6ff6b76f53a0678b53e38"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8b9f159bc2a425d358e960424b0bf6f8634d199a52daf5de7d554551edf670c"
    sha256 cellar: :any_skip_relocation, catalina:       "73f61f10fc96510af6ca99d658cadb10427fdec9cc0ffdfe68534d51dd4f5550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "806e0e9355637ccb789043dc03ff28b34a8d4dbaae8f357b0a2470dd8d22d873"
  end

  depends_on "python@3.10"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/de/eb/1c01a34c86ee3b058c556e407ce5b07cb7d186ebe47b3e69d6f152ca5cc5/psutil-5.9.3.tar.gz"
    sha256 "7ccfcdfea4fc4b0a02ca2c31de7fcd186beb9cff8207800e14ab66f79c773af6"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  def install
    virtualenv_install_with_resources
    prefix.install libexec/"share"
  end

  test do
    read, write = IO.pipe
    pid = fork do
      exec bin/"glances", "-q", "--export", "csv", "--export-csv-file", "/dev/stdout", out: write
    end
    header = read.gets
    assert_match "timestamp", header
  ensure
    Process.kill("TERM", pid)
  end
end
