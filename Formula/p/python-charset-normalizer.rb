class PythonCharsetNormalizer < Formula
  desc "Real First Universal Charset Detector, maintained alternative to Chardet"
  homepage "https://charset-normalizer.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
  sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf56118490db56357ca3c93f9ab7cc47d67059fc6b2a8d98e8706d230f306611"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd8b0e195c0b141f072a48aadca5329215954c94acb929370bc94c9cf7836374"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b66982913189e8ad4f7e10d5516722cf76f2d8b764ce3bafdea67eb3a607b619"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f3436649fe6983ccae0e594fa6adeddc26d8ba76859cd6541263bffc326ebcb"
    sha256 cellar: :any_skip_relocation, ventura:        "34ac7817bc31df65535561b0f4ef5a76b5b98869eb58f55adef16096163cf59d"
    sha256 cellar: :any_skip_relocation, monterey:       "3a9c34b3d07577b21ecc2304892df8071ea544c3f60419867b624ab531f3b92d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c94c6c9984fe7b9e2c079e855886199ba04896fc608f43949bbeda964097949"
  end

  disable! date: "2024-06-23", because: "does not meet homebrew/core's requirements for Python library formulae"

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
      system python_exe, "-c", "import charset_normalizer"
    end
  end
end
