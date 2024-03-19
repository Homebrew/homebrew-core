class PythonPyparsing < Formula
  desc "Python library for creating PEG parsers"
  homepage "https://github.com/pyparsing/pyparsing"
  url "https://files.pythonhosted.org/packages/46/3a/31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842/pyparsing-3.1.2.tar.gz"
  sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08d753c6ae54cbe253b8ac6e1bb2321f298e36ee6242d7c2b5ab59a4904cf2a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0070eaef4288055ec4f9d8278065024d71fd163efd500b907ec07b7f778a5265"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4da6cfb32c7fac5bea1c4c2a2a3c8ffe075bceee17cf6bd9a42c37f6cf9370e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "8047ca6f196bf8add8e84acdf27c140343315436bdb254464798095f1fb9115a"
    sha256 cellar: :any_skip_relocation, ventura:        "69d19eafa74434e37854e4840ed7305a0f17a179f5d23e535c16c0044704484b"
    sha256 cellar: :any_skip_relocation, monterey:       "dda121f09023fa93008c1f7d36e7173041f924e70920b0d3fec2c92a77e76f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "238f79236471779a21a19b4b0082e0970d37548e152ea1aa7b94cbfdb13b80a6"
  end

  depends_on "python-flit-core" => :build
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
      system python_exe, "-c", "import pyparsing"
    end
  end
end
