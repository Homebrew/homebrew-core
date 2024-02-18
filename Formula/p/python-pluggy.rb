class PythonPluggy < Formula
  desc "Minimalist production ready plugin system"
  homepage "https://github.com/pytest-dev/pluggy"
  url "https://files.pythonhosted.org/packages/54/c6/43f9d44d92aed815e781ca25ba8c174257e27253a94630d21be8725a2b59/pluggy-1.4.0.tar.gz"
  sha256 "8c85c2876142a764e5b7548e7d9a0e0ddb46f5185161049a79b7e974454223be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44edda4fb3877f2dba5571eee866e3f923650707a787cec6096b526393be00f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b757978f988472eafdced75e6d9d1f1148277d298d2606d685356ddb18728f9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afd76d1919eec1451ea6ed59277a901e1ed3be170537a1f0cf59498ab93a4bee"
    sha256 cellar: :any_skip_relocation, sonoma:         "1eb6bd9a6266ac1e7fdf6db3bc17e39e46c98261e0c4e6647c0e25ffdbebecf9"
    sha256 cellar: :any_skip_relocation, ventura:        "80fa260a3b49e6c6dc468aeaa4521bf4423abfe2f0c5779f9b94e442c56141cd"
    sha256 cellar: :any_skip_relocation, monterey:       "e26537e3f1a4bef8613d5426bfb14c8e2341a76172740b30c4607cea71f635ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7a1179416253a256833e6bddaa8168f50f9679757bef3a01570b6bfa5bbd54b"
  end

  depends_on "python-setuptools-scm" => :build
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
      system python_exe, "-c", "import pluggy"
    end
  end
end
