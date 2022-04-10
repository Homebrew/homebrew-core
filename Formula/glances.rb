class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/03/43/3850ba52e1ef326b7bf88fc03e63c659269af3b7d706451f9ca911a312f4/Glances-3.2.5.tar.gz"
  sha256 "c9609ad01c391fdd395023ed0eed21373cc3f242c78bede6c64cfa68b370abdf"
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
    url "https://files.pythonhosted.org/packages/47/b6/ea8a7728f096a597f0032564e8013b705aa992a0990becd773dcc4d7b4a7/psutil-5.9.0.tar.gz"
    sha256 "869842dbd66bb80c3217158e629d6fceaecc3a3166d3d1faee515b05dd26ca25"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/31/df/789bd0556e65cf931a5b87b603fcf02f79ff04d5379f3063588faaf9c1e4/pyparsing-3.0.8.tar.gz"
    sha256 "7bf433498c016c4314268d95df76c81b842a4cb2b276fa3312cfb1e1d85f6954"
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
