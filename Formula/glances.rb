class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/a9/52/ae64cd35735f9f8214c5d435f398b47cde3563cb2a243e25348c94a90b68/Glances-3.3.0.1.tar.gz"
  sha256 "0c94636d26f53e61eda72e886501fc42bb1331521038c608d8b38326947de6e1"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a79aecf1c0ec772469291e8a4e78e9d42e82a1f0e9d0211d77cc8a1b8bd5f8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6ec8eb89a8cca98076523cd6f436598f04d9015b8d25431d244113460dd69f2"
    sha256 cellar: :any_skip_relocation, monterey:       "35e98178b35d2deff297b8f4bb69b61b50f1c8827c5f295bc7f9faef4d236e92"
    sha256 cellar: :any_skip_relocation, big_sur:        "387681fa8a1e83081b944c9137d2ceccfe06ca33af76b39f8312a3c165e08fa3"
    sha256 cellar: :any_skip_relocation, catalina:       "c6d8ceb7c5c30f25942e30c12cd4a90b0379680982c1735164ba1e104c8f68dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3b8377423d1d8a06e5b34f0faba12dc290e203f56dc1c0dbee517ec1469f17c"
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
