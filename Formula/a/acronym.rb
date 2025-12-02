class Acronym < Formula
  include Language::Python::Virtualenv

  desc "Python-based tool for creating English-ish acronyms from your fancy project"
  homepage "https://github.com/bacook17/acronym"
  url "https://files.pythonhosted.org/packages/e3/1a/1a364f93053f9ad0d4f38b5c0078637db484bb4c1388ad0234b85c9d2ca8/acronym-2.0.0.tar.gz"
  sha256 "163cc1630b7c65cbca6426f80e267f5253ea787e17a329d1d55517868897bbf1"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28f9d722ad4f7ca4cac9b84faf09f19536bebc7e4fe17887cc1666eac6281f47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f0bf7427caeeb3f33476658bd69bbfebd547df49c90db6a328ebabbbf7b7a78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "527bcd0322a0b731e280b2f75905a19bccd0e14490123f6f3b57709105eb993d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a745d5f44b5fb3d34c850e7d391a19c1e938631cf381b10c5374ae8b29524d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bfabc3eda08a2f8f3c38ccba43b2cc1d34be7cd0ac0880485f5dcc8c6944ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6056bea3ce25ae1105f1de1129a5ca5bbaf133ee2151fd94c841a81062a6fdb5"
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
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/64/33/60135848598c076ce4b231e1b1895170f45fbcaeaa2c9d5e38b04db70c35/joblib-1.4.2.tar.gz"
    sha256 "2382c5816b2636fbd20a09e0f4e9dad4736765fdfb7dca582943b9c1366b3f0e"
  end

  resource "nltk" do
    url "https://files.pythonhosted.org/packages/3c/87/db8be88ad32c2d042420b6fd9ffd4a149f9a0d7f0e86b3f543be2eeeedd2/nltk-3.9.1.tar.gz"
    sha256 "87d127bd3de4bd89a4f81265e5fa59cb1b199b27440175370f7417d2bc7ae868"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/9c/d6/9f8431bacc2e19dca897724cd097b1bb224a6ad5433784a44b587c7c13af/pandas-2.2.3.tar.gz"
    sha256 "4f18ba62b61d7e192368b84517265a99b4d7ee8912f8708660fb4a366cc82667"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/3a/31/3c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3f/pytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/e1/34/943888654477a574a86a98e9896bae89c7aa15078ec29f490fef2f1e5384/tzdata-2024.2.tar.gz"
    sha256 "7d85cc416e9382e69095b7bdf4afd9e3880418a2413feec7069d533d6b4e31cc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "TEMPORAL", shell_output("#{bin}/acronym 'The missing package manager for macOS (or Linux)'")
  end
end
