class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/38/56/d398acd91e0d78590dc6124290f67b3eeeb1ecb6f2610d29060925491553/Glances-3.3.0.tar.gz"
  sha256 "54c2cf2d7f6070741155a129b1e6161a06eae3e7987e759131d76becf18216d2"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb3ee634537487d23c20576ca36ec5f9d2ed6ca19fcc86c6814fcafe3f6a1b4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9db8bec3dcc0f592bd13c5555255ef4bd8af7cadf75b7d9ff461012997a239f"
    sha256 cellar: :any_skip_relocation, monterey:       "c2271504cdfc31be24c4ee5beac66c0a48be209c21cd67c4799f684fa1411359"
    sha256 cellar: :any_skip_relocation, big_sur:        "635ed142c4c9ac96b72806bcf2f201fcc1e29e13a547b82dbda5d66f5fdbdd63"
    sha256 cellar: :any_skip_relocation, catalina:       "2209c12929b64c5f26f391f1200ea96720910a0ccb6e03417877a58fd386b38e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ce45d08247195a753f069fdf578d0ee69a72b1fae0e5eecb09d65ec1533465d"
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
    url "https://files.pythonhosted.org/packages/8f/57/828ac1f70badc691a716e77bfae258ef5db76bb7830109bf4bcf882de020/psutil-5.9.2.tar.gz"
    sha256 "feb861a10b6c3bb00701063b37e4afc754f8217f0f09c42280586bd6ac712b5c"
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
