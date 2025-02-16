class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/c2/62/c7402ffe11d43e88dbab6b7255f16743f8b9cbb3e7d3405f95a677a98c47/img2pdf-0.6.0.tar.gz"
  sha256 "85a89b8abdeef9ef033508aed0d9f1e84fd6d0130e864e2c523f948ec45365e1"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ef6a9b83380ed6d6e6db8160df56b009f26b2e223312cec548702091d3e57693"
    sha256 cellar: :any,                 arm64_sonoma:  "3a0c43020785c35042b8a9add983733936d4abfb2e70060a74b037d2d0a4eff0"
    sha256 cellar: :any,                 arm64_ventura: "45ab8beffeb03e65bc7ab13150333bf33079bd17c647cd7488c0c68aec4f4564"
    sha256 cellar: :any,                 sonoma:        "e858638a52e7b9bce79b9f62705851474f2f1e15727b4c3b8cf45705c0061208"
    sha256 cellar: :any,                 ventura:       "31db47d692ae3532f265bd45aef2c367bafec135bcfd11131240932249344539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3198d4086d1b9c495bdc30287f47d31b789a7abae8927e9f3e758f34035dc7c0"
  end

  depends_on "pillow"
  depends_on "python@3.13"
  depends_on "qpdf"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/98/97/06afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2/deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ef/f6/c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8/lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/1c/2c/0707248e2bdfe148c53c43ea1a7fce730eab9ae8bbe65470720f5a7ddd25/pikepdf-9.5.2.tar.gz"
    sha256 "190b3bb4891a7a154315f505d7dcd557ef21e8130cea8b78eb9646f8d67072ed"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c3/fc/e91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcef/wrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"img2pdf", test_fixtures("test.png"), test_fixtures("test.jpg"),
                             test_fixtures("test.tiff"), "--pagesize", "A4", "-o", "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end
