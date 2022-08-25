class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/b6/70/b40e1d780ef071d9b53a05e86c2584b42afa1e14dc6ed99847947725c681/ocrmypdf-13.7.0.tar.gz"
  sha256 "45fa226f6753f6e0be1e6304d3363a6d8047bb4cb0cf0d25728c3b9c9a0bff40"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fc0cdf1382e63980be844ab60dfa6c1a8fe56cb6bd2218249c5f76ccf5269066"
    sha256 cellar: :any,                 arm64_big_sur:  "d1f4a41cafafce247ce2961f75e79627568bde9defb0879647ab409569795211"
    sha256 cellar: :any,                 monterey:       "2121f1eff069fab3a99ac230b863df6c7bcf61539c7d68e8f4077828ca9bbb87"
    sha256 cellar: :any,                 big_sur:        "dd11ac432cd5df72412b4685bbeef5662859b68f862615898bedc1c96a3ce66b"
    sha256 cellar: :any,                 catalina:       "15c210caa9b0b4a765125fc5c77bc881022863e13e86fc119a28eea620506ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54c04c2c503db4cba0863deff7eec881a78a1ee8db0063a666f7163cdd31892a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jbig2enc"
  depends_on "libpng"
  depends_on "pillow"
  depends_on "pngquant"
  depends_on "pybind11"
  depends_on "python@3.10"
  depends_on "qpdf"
  depends_on "tesseract"
  depends_on "unpaper"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/93/1d/d9392056df6670ae2a29fcb04cfa5cee9f6fbde7311a1bb511d4115e9b7a/charset-normalizer-2.1.0.tar.gz"
    sha256 "575e708016ff3a5e3681541cb9d79312c416835686d054a23accb873b254f413"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/cc/c7/eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325/coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/89/d9/5fcd312d5cce0b4d7ee8b551a0ea99e4ea9db0fdbf6dd455a19042e3370b/cryptography-37.0.4.tar.gz"
    sha256 "63f9c17c0e2474ccbebc9302ce2f07b55b3b3fcb211ded18a42d5764f5c10a82"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
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
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
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
    url "https://files.pythonhosted.org/packages/41/c8/1c2126eb059d47ed899fd5a8ed8d2eddca5cd1e5e9e0c66adf12067a25a6/pikepdf-5.4.2.tar.gz"
    sha256 "8f3a056f7a5647c91fc0861e8ae011c6dd7ecdf6c622ff483739c74887fc3eaa"
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
    url "https://files.pythonhosted.org/packages/a6/d0/bdee3e8a7ba5f2dc8bacea10f4fdd1264b1dd9e53d96d318773180634a00/reportlab-3.6.11.tar.gz"
    sha256 "04fc4420f0548815d0623e031c86a1f7f3f3003e699d9af7148742e2d72b024a"
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
