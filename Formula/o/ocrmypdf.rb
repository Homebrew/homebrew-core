class Ocrmypdf < Formula
  include Language::Python::Virtualenv

  desc "Adds an OCR text layer to scanned PDF files"
  homepage "https://ocrmypdf.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/87/a1/20917b9b0c30f1dc57495409b8e4e0d12966d1bda8b7fe21f6939f54ea6f/ocrmypdf-15.2.0.tar.gz"
  sha256 "4f618e555e607b4dccd45bcf3943d5a526f357002367d5c34b524853922a5bdf"
  license "MPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3f39ff1d94b40b1e79e0b93831b20d9eb1fb29641c15a7b5697581e923988b62"
    sha256 cellar: :any,                 arm64_ventura:  "6d7b620db87846a81ff854b2c8042aa0b9ef536176ba32487b5ca3e9b5953e6d"
    sha256 cellar: :any,                 arm64_monterey: "fd6c5f76445c56effd22dad38cdec6267e3c4be3d0e50d5080aeb2dd8d50c752"
    sha256 cellar: :any,                 sonoma:         "92aeee6690daeb3437aed8ac4de690c4eaf8f94c332ff1c0d61624bc16207d41"
    sha256 cellar: :any,                 ventura:        "8f4a32f7787b967112d007a8988a97ef3cbd85a9acba2351bad1fd8a51c61d97"
    sha256 cellar: :any,                 monterey:       "5fdcecc09b1fc2360f55e59bc441432944ec7153fb2b1f5b68fb36548dbf7707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4c8610781bcbee52d0595f62784b0e424d30d5fee477b6f149442835dce4fdb"
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
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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
    url "https://files.pythonhosted.org/packages/ac/6e/89c532d108e362cbaf76fdb972e7a5e85723c225f08e1646fb86878d4f7f/pdfminer.six-20221105.tar.gz"
    sha256 "8448ab7b939d18b64820478ecac5394f482d7a79f5f7eaa7703c6c959c175e1d"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/10/44/27ab858d600b2196b6699dd854f2439826348fa62c305d83bb799b929bf9/pikepdf-8.5.1.tar.gz"
    sha256 "f1a1de1a241912f96cb202b7ac28b4bc229d66c8bdf08d8dc25144f155adf653"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "reportlab" do
    url "https://files.pythonhosted.org/packages/10/ec/4a423a97e53399c05889cd12f789ab9175f2498c77b47cc006b6482b71c1/reportlab-4.0.5.tar.gz"
    sha256 "9c68f277736f585c5c9938755b826dd57c877fcaeb203e21cefea12b3b1db4f5"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
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

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[img2pdf].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")

    bash_completion.install "misc/completion/ocrmypdf.bash" => "ocrmypdf"
    fish_completion.install "misc/completion/ocrmypdf.fish"
  end

  test do
    system "#{bin}/ocrmypdf", "-f", "-q", "--deskew",
                              test_fixtures("test.pdf"), "ocr.pdf"
    assert_predicate testpath/"ocr.pdf", :exist?
  end
end
