class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/82/c3/023387e00682dc1b46bd719ec19c4c9206dc8eb182dfd02bc62c5b9320a2/img2pdf-0.6.1.tar.gz"
  sha256 "306e279eb832bc159d7d6294b697a9fbd11b4be1f799b14b3b2174fb506af289"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ef3cbeaff3755191c9ce0ee7776a301394eda86f9e86021015c71fa3a0456a6f"
    sha256 cellar: :any,                 arm64_sequoia: "b88958e75b9764269eebec2f048dc3b8a9438c5f5b6165fe0390356fefbeb0db"
    sha256 cellar: :any,                 arm64_sonoma:  "b9588271a96d950bb106f381bd56945d85901564162978052aaf70ff67ae5e11"
    sha256 cellar: :any,                 sonoma:        "ce6146a10bc53c0407359b10e093e4803520d61a00a7cd2982aa19e2573d3a0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f13d064d7511b8f99b887b629f6d1c07e9a54456a91c5c447ad89f6fe34b4eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0da3f0eeb263fb2cedc3426e1b5528a86d693dd6988a231bcd7b9cc573e8cd97"
  end

  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"
  depends_on "qpdf"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: "pillow"

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/98/97/06afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2/deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/f5/4c/62b37a3ee301c245be6ad269ca771c2c5298bf049366e1094cfdf80d850c/pikepdf-9.11.0.tar.gz"
    sha256 "5ad6bffba08849c21eee273ba0b6fcd4b6a9cff81bcbca6988f87a765ba62163"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
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
