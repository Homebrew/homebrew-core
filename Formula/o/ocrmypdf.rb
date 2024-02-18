class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/ff/07/dd520f4371d87eede1b7826fc8ab305fe2844533b2032c8ae4010179aba9/ocrmypdf-16.1.1.tar.gz"
  sha256 "5735cb45a2bba6a56157fffddd038b08dd7f2a1f8a3f9d4724c217d99934a527"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e0d479b2823e39b3aaf29ce6e65bfb9c90466eb37de971f01943535f6be35c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96936962887c6c6e67ba2e65769a502d341e3b381207f492844f137498dee43e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d1100246520e4027a5f1c4b806075011161efd81e0b99a588a35f88cc7395db"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d0ce90438dc21e1eedbae63763dbc24a24216fb2e596601589f6dd35bd1e0dd"
    sha256 cellar: :any_skip_relocation, ventura:        "83d83d05c778cc5a3d99f7776ed620e1473c891ca22346864ab9fd8032c21710"
    sha256 cellar: :any_skip_relocation, monterey:       "14d50dac1eb398c7894c367a61784f5894898c0830356f38696e473f96726e77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66798a4375abe447879ddb18fbcd8878ae8d2d345b56bf7ddf61a748a23540a5"
  end

  depends_on "cffi"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "img2pdf"
  depends_on "jbig2enc"
  depends_on "libpng"
  depends_on "pillow"
  depends_on "pngquant"
  depends_on "pybind11"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-cryptography"
  depends_on "python-lxml"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "qpdf"
  depends_on "tesseract"
  depends_on "unpaper"

  uses_from_macos "libffi", since: :catalina

  fails_with gcc: "5"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pdfminer-six" do
    url "https://files.pythonhosted.org/packages/31/b1/a43e3bd872ded4deea4f8efc7aff1703fca8c5455d0c06e20506a06a44ff/pdfminer.six-20231228.tar.gz"
    sha256 "6004da3ad1a7a4d45930cb950393df89b068e73be365a6ff64a838d37bcb08c4"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/54/c6/43f9d44d92aed815e781ca25ba8c174257e27253a94630d21be8725a2b59/pluggy-1.4.0.tar.gz"
    sha256 "8c85c2876142a764e5b7548e7d9a0e0ddb46f5185161049a79b7e974454223be"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[img2pdf].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")

    bash_completion.install "misc/completion/ocrmypdf.bash" => "ocrmypdf"
    fish_completion.install "misc/completion/ocrmypdf.fish"
  end

  test do
    system bin/"ocrmypdf", "-f", "-q", "--deskew",
                           test_fixtures("test.pdf"), "ocr.pdf"
    assert_predicate testpath/"ocr.pdf", :exist?
  end
end
