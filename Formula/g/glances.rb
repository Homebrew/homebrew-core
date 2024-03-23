class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/2d/5c/628323ef58132b4a093e7182bbb5c5c3063fbd598873f31024b58448be73/Glances-3.4.0.5.tar.gz"
  sha256 "2aaae0222744837e1223f63bd2efffbc6a3fdae42c95b2ebd1925cf94ae2a85b"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94cf86e270364b6d5afa586d699740dee8262295ebcc806959807d2980cc4937"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1d27318512abbb5ef932b174efc7b888b021fdfcdb61f60f0ec25b03aed2e80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "096de5c73c7f4245a974c96ca2e8e7a86d7b56af37203ede48a38bf551423197"
    sha256 cellar: :any_skip_relocation, sonoma:         "d723a52308c014c5e89a8d9a88ccf41fcf3e0b4e10bb924f4578dd0aea8d0bea"
    sha256 cellar: :any_skip_relocation, ventura:        "9142b4ca73e862ab8e3721ac77925ff28c20ed726d2498289cb3b6d0803ba9e7"
    sha256 cellar: :any_skip_relocation, monterey:       "b9832aa17005c5eafb2ec44d81e0613ec28da12d7f13f217876521516862d9a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cefcd43cb168e567d5544477554213c7ffa95b4f2617c042218b3177d74a7a6d"
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
