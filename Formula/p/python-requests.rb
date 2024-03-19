class PythonRequests < Formula
  desc "Python HTTP for Humans"
  homepage "https://requests.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
  sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1607276a72136ed335e4cbf73b43a1e3a6d5936b9e1ea74a5d3f73ef5ee9e6e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef53ca288c1f15629dd76ec733aea0111db0eb562ee9de419e8251acff0622a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afd1100ee1bb35c2c0f6d058fdcd35cc743fbd3c4db0bef7d38f5e454d7a23d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "389f1e4f5336bc90c74f8f14623adbef4dbae7e3b0184b9fb91639eb47cc11ea"
    sha256 cellar: :any_skip_relocation, ventura:        "f505434e2a709c42fb16447e45dc63fb260600aba3f9ec2dc9e32bee813b0980"
    sha256 cellar: :any_skip_relocation, monterey:       "2fa70934730752bef5b1282e063eded8a7f8ff4d14a2d6b865d826d300d8414b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38eb54a3c08da5790c7da2dbbe36992772214a7bf2ce87a73b5f58930ec7b0a8"
  end

  deprecate! date: "2024-03-14", because: "does not meet homebrew/core's requirements for Python library formulae"

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "certifi"
  depends_on "python-charset-normalizer"
  depends_on "python-idna"
  depends_on "python-urllib3"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  def caveats
    <<~EOS
      Additional details on upcoming formula removal are available at:
      * https://github.com/Homebrew/homebrew-core/issues/157500
      * https://docs.brew.sh/Python-for-Formula-Authors#libraries
      * https://docs.brew.sh/Homebrew-and-Python#pep-668-python312-and-virtual-environments
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import requests"
    end
  end
end
