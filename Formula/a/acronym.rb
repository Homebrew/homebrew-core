class Acronym < Formula
  include Language::Python::Virtualenv

  desc "Python-based tool for creating English-ish acronyms from your fancy project"
  homepage "https://github.com/bacook17/acronym"
  url "https://files.pythonhosted.org/packages/e3/1a/1a364f93053f9ad0d4f38b5c0078637db484bb4c1388ad0234b85c9d2ca8/acronym-2.0.0.tar.gz"
  sha256 "163cc1630b7c65cbca6426f80e267f5253ea787e17a329d1d55517868897bbf1"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "703a2052af753d6303dcbca32664a38a033d24350c52d48caac5d0f65162ded0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1279bd8e339303b923cf31e75ae4937e9d3103f59d7ff01e905e6f51585a4e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ea54b3780487ad0d53d6a2afaa26c2492d6516a78f58639168568c6143449b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "02b938f252557fc173ae20c1430fa9e259189d713212d144a7565b9a720273af"
    sha256                               arm64_linux:   "08ac341265bc7c9cdbd684786ba6674f1fb295f83f898bc8ac0dc6f6e38f9d0c"
    sha256                               x86_64_linux:  "084a6c4d8c2f5d5fa096cdbd8eb50f03d5d05d6cd404dd57ad9c24a56fe459ca"
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
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/41/f2/d34e8b3a08a9cc79a50b2208a93dce981fe615b64d5a4d4abee421d898df/joblib-1.5.3.tar.gz"
    sha256 "8561a3269e6801106863fd0d6d84bb737be9e7631e33aaed3fb9ce5953688da3"
  end

  resource "nltk" do
    url "https://files.pythonhosted.org/packages/74/a1/b3b4adf15585a5bc4c357adde150c01ebeeb642173ded4d871e89468767c/nltk-3.9.4.tar.gz"
    sha256 "ed03bc098a40481310320808b2db712d95d13ca65b27372f8a403949c8b523d0"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/2e/0c/b28ed414f080ee0ad153f848586d61d1878f91689950f037f976ce15f6c8/pandas-3.0.1.tar.gz"
    sha256 "4186a699674af418f655dbd420ed87f50d56b4cd6603784279d9eef6627823c8"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8b/71/41455aa99a5a5ac1eaf311f5d8efd9ce6433c03ac1e0962de163350d0d97/regex-2026.2.28.tar.gz"
    sha256 "a729e47d418ea11d03469f321aaf67cdee8954cde3ff2cf8403ab87951ad10f2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "TEMPORAL", shell_output("#{bin}/acronym 'The missing package manager for macOS (or Linux)'")
  end
end
