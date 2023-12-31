class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/16/22/25fac51008f0a4b2186da0dba3039128bd75d3fab8c07acd3ea5894f95cc/mypy-1.8.0.tar.gz"
  sha256 "6ff8b244d7085a0b425b56d327b480c3b29cafbd2eff27316a004f9a7391ae07"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b10f139f236897605fa662f8f640fe4bb34fd5567c50907fa00f86a363677224"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92489f4c06aa4cbcad1c00bd1d5c53025d3fcd497f594ebaca7673fae99071eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9880c004eaeb6ab36557c982108c918b6993dae11d8245d74e9bbc2039e36ea1"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd87326a03f67bd3aadb91a676b63e28a1b7474959b938ebaa4ed8774b2c3493"
    sha256 cellar: :any_skip_relocation, ventura:        "97761f264a84a0b23114ddaf86aa6d062ffd88093d372ae5609f4036e8747aad"
    sha256 cellar: :any_skip_relocation, monterey:       "b1d82b83d2ca6ee112651b8ce57d2d3a7a5fb601696d9defb973b2e0f81894b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23736c9a8ddd7f93d50a0d81563a26efac78d499ec5cf08d5a80ad59f5450074"
  end

  depends_on "python@3.12"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  def install
    ENV["MYPY_USE_MYPYC"] = "1"
    ENV["MYPYC_OPT_LEVEL"] = "3"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def p() -> None:
        print('hello')
      a = p()
    EOS
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output

    output = pipe_output("#{bin}/mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end
