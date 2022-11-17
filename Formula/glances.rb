class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/21/71/4580c2977846c59c3e4a8f16b738a16a4ff3761b323b2f83894c4d699bf5/Glances-3.3.0.4.tar.gz"
  sha256 "8a0a5298ea55e34773eda86c51710a56f19c4724600472627079b1c370f79e4e"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00c117dbdafadc7b85c7ff62d7ebc0ea85e6034b92e8000643d4f1ed70789f93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1e9661ad43f4ea3be24818e10ea850d77380eb1a7080121617143db6797ddeb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f060745e511eafc304a4f945ef50fc70693790bda87f77385084863279d79c0f"
    sha256 cellar: :any_skip_relocation, ventura:        "c99b8aa453b7fe043747a71f6d132f5198837ea894eb4c8c088f3bec343e07a3"
    sha256 cellar: :any_skip_relocation, monterey:       "a894e09c7e3d3e6d63e36874612b9f6bc90b74f16eaa6b3ee14c3af755630310"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0b1c59505c292e21785814c609f1076562b6dcd7e8e93279541a306fb049364"
    sha256 cellar: :any_skip_relocation, catalina:       "6774d0e64a60bb48dda5f505dc9583d6a59cc21907365f6a9511c51fa61c06e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "925d6976ff5cffabd2f573a530870628e3d01f9dc27963205bed584726b7c7c1"
  end

  depends_on "python@3.11"

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
