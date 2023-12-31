class PythonPyparsing < Formula
  desc "Python library for creating PEG parsers"
  homepage "https://github.com/pyparsing/pyparsing"
  url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
  sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96d6d212a3fe03ac8885804a93693170790614f84333718cca324e3398776130"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a56913f480daa513462dbf87ade9f026f2b8c82138ea8c471683f7da00b9ddc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "205d0e87db0215fe709e7cc64d147d8759b30b5ca0639b91a26806d0f20dbdcb"
    sha256 cellar: :any_skip_relocation, sonoma:         "040e377dfef4b970b8386a408f2611bee26307909cfd2012cfc55be9bb8d7f96"
    sha256 cellar: :any_skip_relocation, ventura:        "b04187437131d92647890e8e383e4eacbf98fad80a0b3f5d831f7386e72c3645"
    sha256 cellar: :any_skip_relocation, monterey:       "557da73afc47e34d2f8766aced84737c75e6566af91f45a71ef7d910e96f7b7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c76b19d6058087daa7469ca3ff9659969ca5a0201567b4f1b48c5b22eb8be6ba"
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
