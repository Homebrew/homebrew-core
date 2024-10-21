class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/17/03/744330105a74dc004578f47ec27e1bf66b1dd5664ea444d18423e41343bd/mypy-1.12.1.tar.gz"
  sha256 "f5b3936f7a6d0e8280c9bdef94c7ce4847f5cdfc258fbb2c29a8c1711e8bb96d"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b7ed095d8f8d5474bbffdf558125c450ab8ad179814f1ae419c0d19afa54310"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "420882aa04df35bcd002aa58a87e87e1bf04d482326ab181ffdd49f13f37c2ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bd7340cf15d64aaba7e6f75ff4fe440db058dccfc5a2dbad8e6caec432dcb76"
    sha256 cellar: :any_skip_relocation, sonoma:        "9840bd05c9d7cd89c2950ee8e04a0599b60e196dd29ca5af2bae6315deea38db"
    sha256 cellar: :any_skip_relocation, ventura:       "44683578af3c12dcdbcbd0b59c742dc0b8839bbf1496ebda1dd4e5dffd1773d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e203956c2c9be78de7f77de2bc8616be8ce17f35b5dcf5adfff7661c7d96bf2"
  end

  depends_on "python@3.13"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
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
