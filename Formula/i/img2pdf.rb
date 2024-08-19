class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/36/92/6ac4d61951ba507b499f674c90dfa7b48fa776b56f6f068507f8751c03f1/img2pdf-0.5.1.tar.gz"
  sha256 "73847e47242f4b5bd113c70049e03e03212936c2727cd2a8bf564229a67d0b95"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "409163d7e755470e90dd99f6ecd43e8ea3667bc7055f515cb674c1c4dc193ee4"
    sha256 cellar: :any,                 arm64_ventura:  "0dd1b4daa552ea91bd7cf005284ea07a910be3e6d2bde9fcc370b8388a8ddf18"
    sha256 cellar: :any,                 arm64_monterey: "32cf098e77d5ddacd780be6ae260cecfaa4286127d77c9f8d69ccdd984cf0b15"
    sha256 cellar: :any,                 sonoma:         "3f8a2b4805d9da11a6322ce90888b20dc11d77b3ed8f44b7be6bd5717d2a1503"
    sha256 cellar: :any,                 ventura:        "43ec54d11080a0ef985edab917918f06342196378fd1dd5f02c2688722e03bdd"
    sha256 cellar: :any,                 monterey:       "f67c6f923a5878b8bc0dc8ca71ed0e1585ccdb22fd64e78d3e59549424a968fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed291d08c027fc186d4859dfb69c56993ee0b85ce6d6ebfb60a110a3e315f26b"
  end

  depends_on "pillow"
  depends_on "python@3.12"
  depends_on "qpdf"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/2b/b4/bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845/lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/f4/8a/23f62747cf7ea02cad56d82ca881c3aeba8a2beaf85c209017a18ab6865f/pikepdf-8.13.0.tar.gz"
    sha256 "3bbd79c7cd6630361d83e75132aeaf3a64ceb837f82870bafdc210a31e3d917a"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"img2pdf", test_fixtures("test.png"), test_fixtures("test.jpg"),
                             test_fixtures("test.tiff"), "--pagesize", "A4", "-o", "test.pdf"
    assert_predicate testpath/"test.pdf", :exist?
  end
end
