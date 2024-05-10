class PythonDateutil < Formula
  desc "Useful extensions to the standard Python datetime features"
  homepage "https://github.com/dateutil/dateutil"
  url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
  sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aab852ba6ce0806a009276222a8d463109a2a2c948a4f1f37ec2203aa8ceecfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcdceba5d9561c721de861a8a8e85f66c376c11d2e717e2d826eae3980a9b435"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "893582b90d3ddf03e827bdea23e64aa52e9a68e452787e36f14f4c78723999ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "eaf7877611a68e4c499a6e7a00b0740088d427120264f96e2d77d032c39724f0"
    sha256 cellar: :any_skip_relocation, ventura:        "40022516d6c9ae6c71e1bba5cd0554f63d7d930a025ccac6185076d9c51046c1"
    sha256 cellar: :any_skip_relocation, monterey:       "efa3bb4af762bbcde52ec8d76b7159001ba1431637ef30a56f5cdea7016f2a3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d84889a7dba322bd761da70dc1adcb1af03350e64b816fad72a68ae2d20ded9c"
  end

  disable! date: "2024-07-04", because: "does not meet homebrew/core's requirements for Python library formulae"

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "six"

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
      system python_exe, "-c", "import dateutil"
    end
  end
end
