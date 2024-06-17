class PythonPytz < Formula
  desc "Python library for cross platform timezone"
  homepage "https://pythonhosted.org/pytz/"
  url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
  sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "567cc73e994830e94890bfe3766932251f4d05bf42d4089ae9995dad495a0874"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad6f3af5f008f193bc4cbda15ef3eee58c4cef3fced6d9719349d20813b4d7f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c2266de346f79838cc149c2f8cb5ae7aa4b75a106883d9cdc776da4037949a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "9da7ce182fdf5e01ae8d78d03d1a1152b3877044f9c9731463babe5c6d45108b"
    sha256 cellar: :any_skip_relocation, ventura:        "0035a2871673bf0f1dc510dd821d5b8c8eabdd7bdcc0436d6e6c69299bd62e70"
    sha256 cellar: :any_skip_relocation, monterey:       "57f90b7c222a8f39d133d7dcb67349ef45246cadb2be05899a46d8f5b345d9de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e90e84f24431767d4dd3691b486ca2ffdb3f32a10cd6f89802a0eea587f7533e"
  end

  disable! date: "2024-07-04", because: "does not meet homebrew/core's requirements for Python library formulae"

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

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
      system python_exe, "-c", "import pytz; print(pytz.timezone('UTC'))"
    end
  end
end
