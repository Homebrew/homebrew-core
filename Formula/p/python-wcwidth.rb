class PythonWcwidth < Formula
  desc "Measures the displayed width of unicode strings in a terminal"
  homepage "https://wcwidth.readthedocs.io/en/latest/index.html"
  url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
  sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a4f57808f3aed4aa3767ea8ca5ebb1f9d0b7634d78586de7ee09f463217eccd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6798d33c1a16ddc030314110051a79793f835b738b6ad00e160f02e99ab74758"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2b142a3b74b15a5d9bc613fa8022484940e8cdd4be4497e84d5bec4fa6e680e"
    sha256 cellar: :any_skip_relocation, sonoma:         "def722fb30cf28fb70e8a25535c07642d1ccb026a1460d5e1e34b0c76f69b30d"
    sha256 cellar: :any_skip_relocation, ventura:        "864365d2c01df29f2dd9fa6effa69e5688116ddaa634b150c473cdc843fb0c8c"
    sha256 cellar: :any_skip_relocation, monterey:       "d843e5d8a345055e7dd761d51a7e5adcea1b29332f627c90f418f769fb7705eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24b2abe4213907c5a51183a9f576c5a43d1f4e256a93afcab2a849a872181a2a"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from wcwidth import wcswidth"
    end
  end
end
