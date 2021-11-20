class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/65/86/e0317cf4b604d4fc0d3043849759bd55519312cb61130fa1b389ad0dcbdc/Glances-3.2.4.1.tar.gz"
  sha256 "33853a18fb21a4a83070e28877ea3dc68c85aeeeb67c3b532da0d237369ec16d"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2161747a4283fe5bb14aa7bef2493824fcebf7c81c0d72be397792aadc71f81e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a14a59f4732ccc11865a74bb059d06e12d8f02e442eac8f5464df7d87187962b"
    sha256 cellar: :any_skip_relocation, monterey:       "90ee79690169a183ecae3fb31f5abcb537acf6615998247b7138483b781c0ee9"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf357cfaa047f96c4cccd9671dc1c339af5022ae5d30fab2f5e31a267bddd2f8"
    sha256 cellar: :any_skip_relocation, catalina:       "6e77821dd7393ffbe14484ad40fcaf02446c3f283d8a07d0edfcc5e42bc1e0ad"
    sha256 cellar: :any_skip_relocation, mojave:         "e785dca2522e2e25b2d70e7da24b1409df1e8aa6ac6c0203bd49405b52722a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d320ac2305adbd1cb83a6503928fe26a58dd1e07951703cc34a65b5157ecbe6f"
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
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/ab/61/1a1613e3dcca483a7aa9d446cb4614e6425eb853b90db131c305bd9674cb/pyparsing-3.0.6.tar.gz"
    sha256 "d9bdec0013ef1eb5a84ab39a3b3868911598afa494f5faa038647101504e2b81"
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
