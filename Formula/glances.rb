class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/a9/52/ae64cd35735f9f8214c5d435f398b47cde3563cb2a243e25348c94a90b68/Glances-3.3.0.1.tar.gz"
  sha256 "0c94636d26f53e61eda72e886501fc42bb1331521038c608d8b38326947de6e1"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69a34b33b98d1fa5904fcabacbb552603a1b651b32038390b26642be98b3f791"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ead53c6aaff6f95fe588436490eec0dac23817a83d86d4a7e607d0ee676af2f"
    sha256 cellar: :any_skip_relocation, monterey:       "6cd9eb2e39fe08a20c3ab3ff68e893ca2960700a95cc96e5b95fbc2b476807ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "030279d6ad0d47b1c4731b90f323b91935a5411758c05a273c1c4da34f161ce0"
    sha256 cellar: :any_skip_relocation, catalina:       "fd6338c3394b347365b648914a7228e8499a94f45d3d5f1150911e97c2108150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e94e151b8986cf3c06f7942dad5af4ee1cf8ffae039c4bc6aaa270487cbf8023"
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
