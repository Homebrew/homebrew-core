class Acronym < Formula
  include Language::Python::Virtualenv

  desc "Python-based tool for creating English-ish acronyms from your fancy project"
  homepage "https://github.com/bacook17/acronym"
  url "https://files.pythonhosted.org/packages/e3/1a/1a364f93053f9ad0d4f38b5c0078637db484bb4c1388ad0234b85c9d2ca8/acronym-2.0.0.tar.gz"
  sha256 "163cc1630b7c65cbca6426f80e267f5253ea787e17a329d1d55517868897bbf1"
  license "MIT"
  revision 5

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ca54f6d143055d6562c7225431c169b80964dbff83f370bfb12e642aa9fdc52d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "67ceec788b30221c97af9122e483361b50bc489ca5186f116b80f994af07b52a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e8e7fae4f33b048eb99598a114bac2e06be5f4a48da5517620dfe041c284215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1574b1b3736f8d5c785dc7b79c2d68052a5272ca48ca872c8043760ace869e1c"
    sha256 cellar: :any,                 arm64_linux:       "c126a4ec1454bb29e7ec32469ce730eca812d3eb2576356a75322257db8c5a65"
    sha256 cellar: :any,                 x86_64_linux:      "ed818ec3e73bad52271ac423eddbf8cb783c4deb9ba68e6e9e207d583a1471cb"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "numpy"
  depends_on "python@3.14"

  on_linux do
    depends_on "patchelf" => :build
  end

  pypi_packages exclude_packages: "numpy"

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/41/f2/d34e8b3a08a9cc79a50b2208a93dce981fe615b64d5a4d4abee421d898df/joblib-1.5.3.tar.gz"
    sha256 "8561a3269e6801106863fd0d6d84bb737be9e7631e33aaed3fb9ce5953688da3"
  end

  resource "nltk" do
    url "https://files.pythonhosted.org/packages/e0/e6/fe51d2bb1a3b446f59c5c8165999a9fee208bc346af90a7cbf7657bc0d75/nltk-3.10.3.tar.gz"
    sha256 "bb9327a461c3811c2fa4900e03840401f2126adfb30c0072827c433bd2444ea4"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/be/4f/5f3422a2afec5ffc46308b79e53291365a93748b498ac2e58bead0197916/pandas-3.0.5.tar.gz"
    sha256 "dca3734d6ab7c906e6730f0788b0a1dbb9f2467731f9711f77995c8e9d62d712"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/20/98/04b13f1ddfb63158025291c02e03eb42fbb7acb51d091d541050eb4e35e8/regex-2026.7.19.tar.gz"
    sha256 "7e77b324909c1617cbb4c668677e2c6ae13f44d7c1de0d4f15f2e3c10f3315b5"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/21/3b/6c24bec5be5e743ffd99576daa5cc077722fc7d5bbc00bd133fa0c698dc6/tqdm-4.70.0.tar.gz"
    sha256 "55b0b0dbd97462d06ebee91e4dac24ed4d4702be82b24f07e6c1d27e08cea220"
  end

  # Although the virtualenv_install_with_resources uses the package resources listed above,
  # pip still needs to fetch the project's chosen build system via the network.
  deny_network_access! [:postinstall]

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "TEMPORAL", shell_output("#{bin}/acronym 'The missing package manager for macOS (or Linux)'")
  end
end
