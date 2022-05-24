class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/08/79/f8551823fbd9ddcb4d62e9adc0265a35a399cea3afe020e9316f51ac4fc3/Glances-3.2.4.2.tar.gz"
  sha256 "5593f5ba8eca69beb91086bc4cc45473c2d4713839e80a26e2acc96264f23926"
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
