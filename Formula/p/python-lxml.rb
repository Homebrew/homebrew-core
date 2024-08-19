class PythonLxml < Formula
  desc "Pythonic binding for the libxml2 and libxslt libraries"
  homepage "https://github.com/lxml/lxml"
  url "https://files.pythonhosted.org/packages/63/f7/ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055b/lxml-5.2.2.tar.gz"
  sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00da0d292782cc8f590a3f25255065b7c50468b653564cded6374f310f5cdbc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cb01e1f9efb6881f8b372c4afafa2a5beed53da457fd6b1773808737d17b138"
    sha256 cellar: :any,                 arm64_monterey: "0aabaeae58992c0ce648e36b2b22e637e61e3c52150b048fd52ab0a839e77f72"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f8668f58af29d86aa4eea49574e4de7ecf56b1513cb2285dd50b6eb2aaf851a"
    sha256 cellar: :any_skip_relocation, ventura:        "37914264da3b2e4efa00fb06ea69d22616b65210852442566ede657ab80207d3"
    sha256 cellar: :any,                 monterey:       "ce1d7eea93c621928601d6d32a9f582cf6a65f72c248ce1c15a5e0c9b269f09e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b31cc2b8833b956f4c76074ecaf21e6beb505dc3913a4d9da57b8bb1cf9bc160"
  end

  disable! date: "2024-08-15", because: "does not meet homebrew/core's requirements for Python library formulae"

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
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
      system python_exe, "-c", "import lxml"
    end
  end
end
