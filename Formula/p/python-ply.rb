class PythonPly < Formula
  desc "Python Lex & Yacc"
  # homepage ssl cert issue report, https://github.com/dabeaz/ply/issues/295
  homepage "https://github.com/dabeaz/ply"
  url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
  sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54d66e3ac6b55f14eb0f6490394050b4da74cd082fa96c60081d7de50de883c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b3ef7b1b54e137387f1a0ed5f592376237e6586b46c8b04e7df2c7103b87aff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbaf1ce8bb72fdefac197da4df762d1f1c0c30272205ee029b97e2328affaac6"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc7a1c7d224d497ed893acc992431ae4d6828dc48a6f695be25174ca3b659f5e"
    sha256 cellar: :any_skip_relocation, ventura:        "4a6627594316593b40c75d8e5571a27f5d9e9b8be6f381654e558eba9a75c8ca"
    sha256 cellar: :any_skip_relocation, monterey:       "387e60140d3f3328b8230a034bf30040cd62ca8cf834d8b0666307b8411da332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bace34ed66192918877a28f51c5452e7d5b04aaaa91bc90f4edde60ea58d976"
  end

  disable! date: "2024-08-15", because: "does not meet homebrew/core's requirements for Python library formulae"

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
      system python_exe, "-c", "import ply.lex, ply.yacc"
    end
  end
end
