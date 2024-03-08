class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/72/1e/a587a862c766a755a58b62d8c00aed11b74a15dc415c1bf5da7b607b0efd/mypy-1.9.0.tar.gz"
  sha256 "3cc5da0127e6a478cddd906068496a97a7618a21ce9b54bde5bf7e539c7af974"
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
    url "https://files.pythonhosted.org/packages/16/3a/0d26ce356c7465a19c9ea8814b960f8a36c3b0d07c323176620b7b483e44/typing_extensions-4.10.0.tar.gz"
    sha256 "b0abd7c89e8fb96f98db18d86106ff1d90ab692004eb746cf6eda2682f91b3cb"
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
