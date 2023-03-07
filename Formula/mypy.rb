class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/62/54/be80f8d01f5cf72f774a77f9f750527a6fa733f09f78b1da30e8fa3914e6/mypy-1.1.1.tar.gz"
  sha256 "ae9ceae0f5b9059f33dbc62dea087e942c0ccab4b7a003719cb70f9b8abfa32f"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bad7ccbabdda78fa9e15b660d9ca22b9ca2840143f8ab85c60799baeff42b398"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d12dce87030225bab408f42878a90d8835b9126f95bdbda1229f690719e7b52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1cc690d032bb50ab02e3a684ce6d2475814d3dd6ff83e8371ab9ef959b4e29f"
    sha256 cellar: :any_skip_relocation, ventura:        "9c9a4356a258abf1c664685ed1dfd91082d5f3c435420f6ed475aecb5bad153a"
    sha256 cellar: :any_skip_relocation, monterey:       "447085199ef759257e0a08d076ac54c448b84a654997f792c1a776ac19950480"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6d6edceb27169b9ccc0262073c15e871b42af61c5ecc4ac95a5a844df1daec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2355b369169417f46efc38bd124816ae9f627637a8843de915fc1b6a04ea5fb8"
  end

  depends_on "python@3.11"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/d3/20/06270dac7316220643c32ae61694e451c98f8caf4c8eab3aa80a2bedf0df/typing_extensions-4.5.0.tar.gz"
    sha256 "5cb5f4a79139d699607b3ef622a1dedafa84e115ab0024e0d9c044a9479ca7cb"
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
