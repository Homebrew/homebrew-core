class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/95/b5/f933f482a811fb9a7b3707f60e28f2925fed84726e5a6283ba07fdd54f49/img2pdf-0.4.4.tar.gz"
  sha256 "8ec898a9646523fd3862b154f3f47cd52609c24cc3e2dc1fb5f0168f0cbe793c"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "83543aafc2b842e677726ed4afc43e3bf25bd836e3d8ae3648894dc9264ee224"
    sha256 cellar: :any,                 arm64_ventura:  "0c49c0cb4274a79378c9640264bbd04cd7bddfd4d35c69b344438887d868ad1f"
    sha256 cellar: :any,                 arm64_monterey: "77c8bd45f602e7192fe734c89dfc752e140cce963f5260d39d45a846d1d6b2a0"
    sha256 cellar: :any,                 sonoma:         "4a86fa2455b2bbbaa1d32d6c9f707ff6ba5d837a53ea304ff5b0dc887e8b31cc"
    sha256 cellar: :any,                 ventura:        "fcbf8a53b23c1329b184c475316864cf62a1900d0e15d5ac0d6409256b9061e9"
    sha256 cellar: :any,                 monterey:       "30837a428470d2600616b09f979ac631f50fdf416abee96b5ce75dafe2e83042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8893acca7dcecba310733d84246e18b061ae84de185bf688da0f9651eb7ffdd0"
  end

  depends_on "pillow"
  depends_on "python-lxml"
  depends_on "python-packaging"
  depends_on "python@3.11"
  depends_on "qpdf"

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
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
