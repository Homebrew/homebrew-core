class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/e6/5b/dcf4cf3efd388a1226f9fecec19420294a318fd999bd644af6fb19392134/ocrmypdf-13.4.7.tar.gz"
  sha256 "8a0a2fa07cf0aac4dea11990d27a15b552afa7ff2dfffdb322bfd8bd0b77751d"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "016ac13bddf25a76eddc091326fc7bcef20ead5194c6517f2b09637a0e947f95"
    sha256 cellar: :any,                 arm64_big_sur:  "4fbe32a62d408152a6da6dace24f01d7464b0c8a41e29bdb0b9c1f7d54b46d86"
    sha256 cellar: :any,                 monterey:       "361fc15fafa92d13cb14d9de09dffd33be0019dc247cede1e9479b22929f2e91"
    sha256 cellar: :any,                 big_sur:        "1976120edc2efb27ab8864232f28f3d96e150b0a8d4ef63750ed676858e9de15"
    sha256 cellar: :any,                 catalina:       "e56371b69aab4bf159633b42edf699683f5ff2bda747f11dd97ad11915476ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "983398c5cde6f4fc75379c7fdd3926f2a5b76f544571e5ae255af7e3aa15983b"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jbig2enc"
  depends_on "libffi"
  depends_on "libpng"
  depends_on "pillow"
  depends_on "pngquant"
  depends_on "pybind11"
  depends_on "python@3.9"
  depends_on "qpdf"
  depends_on "tesseract"
  depends_on "unpaper"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/cc/c7/eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325/coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/51/05/bb2b681f6a77276fc423d04187c39dafdb65b799c8d87b62ca82659f9ead/cryptography-37.0.2.tar.gz"
    sha256 "f224ad253cc9cea7568f49077007d2263efa57396a2f2f78114066fd54b5c68e"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/95/b5/f933f482a811fb9a7b3707f60e28f2925fed84726e5a6283ba07fdd54f49/img2pdf-0.4.4.tar.gz"
    sha256 "8ec898a9646523fd3862b154f3f47cd52609c24cc3e2dc1fb5f0168f0cbe793c"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/23/bda4e9881090f0f5e33e2efe89aacfa0668eb6e1ab2de28591e2912d78d4/lxml-4.9.0.tar.gz"
    sha256 "520461c36727268a989790aef08884347cd41f2d8ae855489ccf40b50321d8d7"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pdfminer.six" do
    url "https://files.pythonhosted.org/packages/73/42/b6b37b4d70c68dcf8f33a9858a02685f8ca5b42312e276fab56c1299967e/pdfminer.six-20220524.tar.gz"
    sha256 "5a64c924410ac48501d6060b21638bf401db69f5b1bd57207df7fbc070ac8ae2"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/70/4c/0b6a5bf4855d8db580ca377c320b6709ed789f314355f2bd726cb7528b8f/pikepdf-5.1.3.tar.gz"
    sha256 "c34e4239661d2ddf23caa1c4256f636c866ce8069a5052a2bf8ee06e3cae22f3"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/16/31/81ff7e3f9fd345cd4685f964fbc3d89a06f39a4f552ab1c2a5769a0f9013/reportlab-3.6.9.tar.gz"
    sha256 "5d0cc3682456ad213150f6dbffe7d47eab737d809e517c316103376be548fb84"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/98/2a/838de32e09bd511cf69fe4ae13ffc748ac143449bfc24bb3fd172d53a84f/tqdm-4.64.0.tar.gz"
    sha256 "40be55d30e200777a307a7585aee69e4eabb46b4ec6a4b4a5f2d9f11e7d5408d"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    resource("reportlab").stage do
      (Pathname.pwd/"local-setup.cfg").write <<~EOS
        [FREETYPE_PATHS]
        lib=#{Formula["freetype"].opt_lib}
        inc=#{Formula["freetype"].opt_include}
      EOS
      venv.pip_install Pathname.pwd
    end
    venv.pip_install resources.reject { |r| r.name == "reportlab" }
    venv.pip_install_and_link buildpath

    bash_completion.install "misc/completion/ocrmypdf.bash" => "ocrmypdf"
    fish_completion.install "misc/completion/ocrmypdf.fish"
  end

  test do
    system "#{bin}/ocrmypdf", "-f", "-q", "--deskew",
                              test_fixtures("test.pdf"), "ocr.pdf"
    assert_predicate testpath/"ocr.pdf", :exist?
  end
end
