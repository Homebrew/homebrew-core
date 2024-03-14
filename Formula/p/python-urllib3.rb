class PythonUrllib3 < Formula
  desc "HTTP library with thread-safe connection pooling, file post, and more"
  homepage "https://urllib3.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
  sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68346b40c64380528096a15eb4abb3a0d63a0777b12bcb38b02d053df0c49e3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d07ef1e04607dcf20ea254e5401db471e78804b8b834c7a10e7b7fcf503be4da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee2d5f78b7846dc93cd36fb30311d1cd6a927f981461a363be254526f0e3d3f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f3277c0094b71f66a39c0d620613c2910fce882433a775e55004f66aeb590b8"
    sha256 cellar: :any_skip_relocation, ventura:        "1f81b664c6227effdb59978bd34f0418aee777a12372a9c14f8aa947378c10e5"
    sha256 cellar: :any_skip_relocation, monterey:       "5d9940962f71c693e6377190c5f7da4cac1897c6d49d99ee057c9e7c05adfd4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a93d805dc32d35932eeb16e26b24bf513e53815cea88aada3d5da426bf91fa07"
  end

  deprecate! date: "2024-03-14", because: "does not meet homebrew/core's requirements for Python library formulae"

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
      system python_exe, "-c", "import urllib3"
    end
  end
end
