class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/82/c3/023387e00682dc1b46bd719ec19c4c9206dc8eb182dfd02bc62c5b9320a2/img2pdf-0.6.1.tar.gz"
  sha256 "306e279eb832bc159d7d6294b697a9fbd11b4be1f799b14b3b2174fb506af289"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1079b3b50de55ff2cb1ddba4de0b6263eb02e19e4b8c71b789a6e06c5a6eb592"
    sha256 cellar: :any,                 arm64_sonoma:  "3de734f6984a7b7e9642891724dabaa3f21d61627c82d06a5d43828eaaf2933e"
    sha256 cellar: :any,                 arm64_ventura: "e43e023adc6d723aeba2a655fe2aa389ed431132cad290adf7a9fe40e361879c"
    sha256 cellar: :any,                 sonoma:        "a23983ca26c2f1334d67ab269a3710623e3ccf836e05fe29709275a1bb69221b"
    sha256 cellar: :any,                 ventura:       "baf5c53f44485b93ba85f1ca2da11ad6afb6537ccf810e768ca539e9d9e55fcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5420086a7f5c69c6afdc715b30a04b2956e4bb62ebc50c32f3080e7057e8444a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4ef1ecb337f847a0348943032ef9432b5b5c012ae95c45fb6182fefa6e8dfa4"
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
    url "https://files.pythonhosted.org/packages/76/3d/14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08f/lxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/9d/eb/4756ba366b5b243a1b5711e02993ea932d45d7e2d750bf01eb0029dc443e/pikepdf-9.7.0.tar.gz"
    sha256 "ab54895a246768a2660cafe48052dbf5425c76f6f04e0f53b911df6cfd7e1c95"
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
