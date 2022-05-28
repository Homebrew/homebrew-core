class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/62/ae/e78752833a1a198bd62bc5ad633b2f5762ba1240e55c45605a9920c5d6e4/Glances-3.2.6.4.tar.gz"
  sha256 "43f4abd140e3e83bbcd514e8b88af99c3b11803141197f4e5de486dd7174186b"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c02b3d49b3ebba291c0b6e4ce0095e562abdead9354052fdbfc6ec14b16e73f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50de8dfa5f239d7c3c555e1bc7f8c60547a736c587dc77ad9f9b43a103281f6a"
    sha256 cellar: :any_skip_relocation, monterey:       "9bac9fa72cdb071f96672c0fd16dae1ffd47b6b5ed5e2fc425cf4247aa9b6ceb"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e9ed107289d05d34665b96e7b962d80114e595b3b6723a9cb6094e45cd704e1"
    sha256 cellar: :any_skip_relocation, catalina:       "4854dfd3bb32a34fd968ce4a81a8dd92b30323a60309177703e2ad856c94f4c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4c919f5b8495ec14de3144af4090f0c261eff035539b1af41aa29403eb80754"
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
