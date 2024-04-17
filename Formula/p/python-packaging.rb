class PythonPackaging < Formula
  desc "Core utilities for Python packages"
  homepage "https://packaging.pypa.io/"
  url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
  sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  license any_of: ["Apache-2.0", "BSD-2-Clause"]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2cf07e8f77ff012e840b93321f30017d29b0b9408e11b8071ee0b4bbd647bcd1"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
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
      system python, "-c", "import packaging"
    end
  end
end
