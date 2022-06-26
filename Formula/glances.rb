class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/62/ae/e78752833a1a198bd62bc5ad633b2f5762ba1240e55c45605a9920c5d6e4/Glances-3.2.6.4.tar.gz"
  sha256 "43f4abd140e3e83bbcd514e8b88af99c3b11803141197f4e5de486dd7174186b"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42205b8f86e07152b04e3b7fe3306fd74d5f8da9174a7295678a0b494d36acec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b53e981929fd2585113a55bfb229d47eceb7e9a8201dc0a328ac20bca0e452d8"
    sha256 cellar: :any_skip_relocation, monterey:       "5a90eeb85dfe91a1279e9be81a6e5e973b758f224206d8904145b0a11a2a03c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a782823dec42d7e427ec7f98aedb5fa24b11e2ae4a3a9af46f56fc4fcb47ed57"
    sha256 cellar: :any_skip_relocation, catalina:       "9358ab788b1381e6162a4e590eb5539f06ff86806c7b8e3038e0e54dafcc15ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d3d70c53e8856b67281133e5677c5854dee698c4306f9129bfeb866c0275324"
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
    url "https://files.pythonhosted.org/packages/d6/de/0999ea2562b96d7165812606b18f7169307b60cd378bc29cf3673322c7e9/psutil-5.9.1.tar.gz"
    sha256 "57f1819b5d9e95cdfb0c881a8a5b7d542ed0b7c522d575706a80bedc848c8954"
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
