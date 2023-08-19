class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/95/b5/f933f482a811fb9a7b3707f60e28f2925fed84726e5a6283ba07fdd54f49/img2pdf-0.4.4.tar.gz"
  sha256 "8ec898a9646523fd3862b154f3f47cd52609c24cc3e2dc1fb5f0168f0cbe793c"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c8e3cb9c1b3514b7819bdd313028d27b1ec78802a4131d6959f3164fdf874bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d83dba107045082f836bd9f2e5e7b306c4666305257225ac7529d11f2f53200"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "266344cec47449db6d83bf6ce3edeb6b5c8c7ccfa2296eccb04ca6bfb2177a86"
    sha256 cellar: :any_skip_relocation, ventura:        "b98cdd0bd60b4418985eaa5e0d6288b94d35466f5c75ea132394d25d248539b5"
    sha256 cellar: :any_skip_relocation, monterey:       "79e765982507d9dcb34087f631f324cfa31878e59996d8bade4a40ca10fd7c1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "04b58a1110326cf84d83ef5447f0df8d6d3ff43d6c626b908b5e3f5b1f5ed7b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c237ce7d11cc856e78825f611775ecf78c385fd90739ad3cd9ad493d7937b6cb"
  end

  depends_on "pillow"
  depends_on "python@3.11"
  depends_on "qpdf"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78/lxml-4.9.3.tar.gz"
    sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/d0/a3/b4951d002af6fc1fc6a938ce48f82c0561f18bbcb4fca64910b01c801bf2/pikepdf-8.2.3.tar.gz"
    sha256 "77dc52bc0064af10abce890bc0e2496d57ba766e0946a5ac8701a853b00f3403"
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
