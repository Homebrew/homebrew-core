class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/36/92/6ac4d61951ba507b499f674c90dfa7b48fa776b56f6f068507f8751c03f1/img2pdf-0.5.1.tar.gz"
  sha256 "73847e47242f4b5bd113c70049e03e03212936c2727cd2a8bf564229a67d0b95"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5cf6fe368cb747f5a59ef5d497b5bfda7d999cdb136f5d8a7d6a87355dcc78ba"
    sha256 cellar: :any,                 arm64_ventura:  "477a3a5df8e05cc52dd82f19de887ebbc1786561ab8d4b82a8d5da44564443cb"
    sha256 cellar: :any,                 arm64_monterey: "b76dcb24356ed2d304a5fb40061b9a6045cb0fa5b9b5622d5c6f5a7900e749fd"
    sha256 cellar: :any,                 sonoma:         "28ec3b3b256b8d91f305bef63efc5b541254416f2bc3b02080e14105e175ccc9"
    sha256 cellar: :any,                 ventura:        "cb2de4afdf6f787845774ac03f044373106a0cf5398fa522679b1050d9c69424"
    sha256 cellar: :any,                 monterey:       "f722068d35a42b0a794b58603efe738452bc40005fa0fec35f6bd3a91cb55750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f51551d67b6158fada6dd0b76bc56ba2e84a2908382c440c4923a63887aaa78"
  end

  depends_on "pillow"
  depends_on "python-lxml"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "qpdf"

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/5b/1e/522532f009bd0ef8948b2b5e059dca57ea884b5a77651cc7e5fb16439087/pikepdf-8.10.1.tar.gz"
    sha256 "0ed9c0f2908e05e8fdeab14ad73d25924da90f57d3485f3a01acfac6078396af"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/img2pdf", test_fixtures("test.png"), test_fixtures("test.jpg"),
                             test_fixtures("test.tiff"), "--pagesize", "A4", "-o", "test.pdf"
    assert_predicate testpath/"test.pdf", :exist?
  end
end
