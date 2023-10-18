class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/50/f8/0a8d4d8781b41b445534bc4f9210b7793bf0ab52aacfd06ebd2699663e2c/mypy-1.6.1.tar.gz"
  sha256 "4d01c00d09a0be62a4ca3f933e315455bde83f37f892ba4b08ce92f3cf44bcc1"
  license "MIT"
  revision 1
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55efdfb633e1bf3168afbfc768cb2883e7940a869f5a376617055d14e58b1282"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61f88c552c5ddfa49e7dab1bb2b4c798385ae75e54786adba0f1ae72455d5576"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e542b07eea57db32f16e30f0a8fffddd628c42470fbac8f9c17279850df5a8ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "132e26cff6e3dece103787dd3b14e1fadfbac8997315b6a32de28ed52e139a00"
    sha256 cellar: :any_skip_relocation, ventura:        "f448d85a3281b8db8b56e3f64e8fbc6ccd1a73a1fbf60a366dc5277f1eab4919"
    sha256 cellar: :any_skip_relocation, monterey:       "221342f70b8ca5fb001cc6d45c910eeeefd5113db3abd8c086e5a6f93455a6c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f084ee2e800be5d526f0a88000f56e1ae82af32bc513e9acea047901288ee3e"
  end

  depends_on "python@3.12"

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
