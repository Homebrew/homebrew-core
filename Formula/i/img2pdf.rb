class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/c2/62/c7402ffe11d43e88dbab6b7255f16743f8b9cbb3e7d3405f95a677a98c47/img2pdf-0.6.0.tar.gz"
  sha256 "85a89b8abdeef9ef033508aed0d9f1e84fd6d0130e864e2c523f948ec45365e1"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a5ebd58206276d9220b4e2b458befe3868ab5d7ed2d177316242fdc1facb2daa"
    sha256 cellar: :any,                 arm64_sonoma:  "90b252551ff71588ebdfcb59807a44c29d0f6a50e77b6beb8e66be6cb9bef8d7"
    sha256 cellar: :any,                 arm64_ventura: "8c4928259d71cd47b7a1ad76f4cfcd433efcd40fc78a74004bd9de958b3c1601"
    sha256 cellar: :any,                 sonoma:        "73a809ba81e45f22251450ae5f7b9d1a998ca95c5906154e21e33706265447ae"
    sha256 cellar: :any,                 ventura:       "79f3d0152ffb4d461166ae20ddacf08b84f7630eb36ad1cf0875fbb8bab91cab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8257aca4a22a7abc29ebbef06a186902624e0f61f674c36d3dc2743c182f25f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f0d501f933a9c6d8c02c415e0c3c7931f6c301ff3d30ff4bda7f1910100e153"
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
