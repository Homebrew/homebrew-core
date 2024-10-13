class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/2c/85/439deb5b418261dbfd844dbae8c1d8713c9c7bc5dd36a59577a77d7ffbbb/ocrmypdf-16.5.0.tar.gz"
  sha256 "cd96bddfb3a986be7bf7857757919332e1db5dab780eb7b321fdea38f60127ac"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "578d34e7fc7fabcdc8d9a93858a2d2ffecc53474a822075dc124a5ddabce941c"
    sha256 cellar: :any,                 arm64_sonoma:   "ba66320394edb0c2d3db4951022117bc1b4512cf3be351cac9ee461e1727744b"
    sha256 cellar: :any,                 arm64_ventura:  "cb2f27a81182604604b82b38df25f62cb0fc7635040832fa6dda8563b694c149"
    sha256 cellar: :any,                 arm64_monterey: "c25265f48bce9e10f80863e5524ea6d3cba54148e2bc108da3209020c0e137d3"
    sha256 cellar: :any,                 sonoma:         "ce2ebd67be7c626f6d51ee7f5c85675b400f2b02ed4e2d5b3da671f7d29df94d"
    sha256 cellar: :any,                 ventura:        "4b38e1d045dcb84f1285cd5e10ecdbd9ac2bf1e0c0f2184ce7fdc4f5ddaef8d8"
    sha256 cellar: :any,                 monterey:       "09ae46940d17c6eb9ac4869673e6b7ec92051fc2daa8964b332e00191fb3005b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b8e8701c3a16b56d4f647b4a0a69284eec27ae2f8dcbfb22c7ebf977ab02a3a"
  end

  depends_on "pkg-config" => :build
  depends_on "cryptography"
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "img2pdf"
  depends_on "jbig2enc"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "pillow"
  depends_on "pngquant"
  depends_on "pybind11"
  depends_on "python@3.12"
  depends_on "qpdf"
  depends_on "tesseract"
  depends_on "unpaper"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  fails_with gcc: "5"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "img2pdf" do
    url "https://files.pythonhosted.org/packages/36/92/6ac4d61951ba507b499f674c90dfa7b48fa776b56f6f068507f8751c03f1/img2pdf-0.5.1.tar.gz"
    sha256 "73847e47242f4b5bd113c70049e03e03212936c2727cd2a8bf564229a67d0b95"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pdfminer-six" do
    url "https://files.pythonhosted.org/packages/e3/37/63cb918ffa21412dd5d54e32e190e69bfc340f3d6aa072ad740bec9386bb/pdfminer.six-20240706.tar.gz"
    sha256 "c631a46d5da957a9ffe4460c5dce21e8431dabb615fee5f9f4400603a58d95a6"
  end

  resource "pi-heif" do
    url "https://files.pythonhosted.org/packages/8e/12/b477e3bc1ce4a7e9db9ff85f22c89ccd5199c04c150d9cef1bbd444b1672/pi_heif-0.18.0.tar.gz"
    sha256 "0a690159607beaa6712f2c8abaa5168a22314d18f00a617d691548f5acba8070"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/1a/7b/da1b6baeb4361420d6531c90723b33a6e0071118316950a3b35be8375e0c/pikepdf-9.2.0.tar.gz"
    sha256 "a666479a5a8cd5d8b86baa1010e5517c2c60dc3df586accacbd94377b744f034"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/96/2d/02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6/pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/cf/60/5959113cae0ce512cf246a6871c623117330105a0d5f59b4e26138f2c9cc/rich-13.8.0.tar.gz"
    sha256 "a5ac1f1cd448ade0d59cc3356f7db7a7ccda2c8cbae9c7a90c28ff463d3e91f4"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "misc/completion/ocrmypdf.bash" => "ocrmypdf"
    fish_completion.install "misc/completion/ocrmypdf.fish"
  end

  test do
    system bin/"ocrmypdf", "-f", "-q", "--deskew",
                           test_fixtures("test.pdf"), "ocr.pdf"
    assert_predicate testpath/"ocr.pdf", :exist?
  end
end
