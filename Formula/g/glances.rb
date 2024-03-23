class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/2d/5c/628323ef58132b4a093e7182bbb5c5c3063fbd598873f31024b58448be73/Glances-3.4.0.5.tar.gz"
  sha256 "2aaae0222744837e1223f63bd2efffbc6a3fdae42c95b2ebd1925cf94ae2a85b"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb0171b9330e64101f124a84c6f9ae6ba2673ebc8b4b4d7ec593d5ee67aeebfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d311a5456063ca3321978458d4e1dee26c48b227594bc0efec0bdf32cf43d45c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1526d01c2cd68a41efb1f9638727f62921baeb8db02cd2f6267ba3879e56c98"
    sha256 cellar: :any_skip_relocation, sonoma:         "2aad74ca872e153376265e88605bdcc46c0d6107ef03269c6dc8cf36618e208c"
    sha256 cellar: :any_skip_relocation, ventura:        "44f9428eb2ff986ef51c52664503b50ac70b72869e24947ef1c36cf12c25b485"
    sha256 cellar: :any_skip_relocation, monterey:       "e653240ae3b6e1111760da11b1954af2a3ee227e87393175890c31537385f6bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "592fd120e04f6830f4ee0792d563c4163413770e5f84601e21885333866eb7e0"
  end

  depends_on "python@3.12"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/6e/54/6f2bdac7117e89a47de4511c9f01732a283457ab1bf856e1e51aa861619e/ujson-5.9.0.tar.gz"
    sha256 "89cc92e73d5501b8a7f48575eeb14ad27156ad092c2e9fc7e3cf949f07e75532"
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
