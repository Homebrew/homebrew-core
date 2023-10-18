class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/f0/d2/28b0e3f058c2950236d176e93167f0b503bd2e4e4cbd54e306d3c95d413f/mypy-1.6.0.tar.gz"
  sha256 "4f3d27537abde1be6d5f2c96c29a454da333a2a271ae7d5bc7110e6d4b7beb3f"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5ea13c9e2f8239b8beddb28f91cbd902efb5210f6dd1067a06196ec9ab7ef8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca2f1c5097c710fc061d55697aacfeba1fa771ef70325cf05b0e7ff2b27fe180"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49c4bf9e4a36d98ee30e1840b5b66453cd16267b3bfc1432ea9e9d33e4275454"
    sha256 cellar: :any_skip_relocation, sonoma:         "62da6b691367e5c7638d3aa91c880d1a651839f1092319fedea6d161f49cde16"
    sha256 cellar: :any_skip_relocation, ventura:        "4c7e271adeb41e9abfbb68b467a2485086b9db5ba148a56938b1e7d716ddc7ee"
    sha256 cellar: :any_skip_relocation, monterey:       "34ddee5abacad023d0ec796c03145524b2d3c922beead39f1d36ee87e3cec82d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f803c37296c90388825b9a979f85243c644852d878a2dc02f7f63b8888817a8"
  end

  depends_on "python@3.11"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  # The `python-typing-extensions` formula depends on `mypy`, so we use a resource here instead
  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/1f/7a/8b94bb016069caa12fc9f587b28080ac33b4fbb8ca369b98bc0a4828543e/typing_extensions-4.8.0.tar.gz"
    sha256 "df8e4339e9cb77357558cbdbceca33c303714cf861d1eef15e1070055ae8b7ef"
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
