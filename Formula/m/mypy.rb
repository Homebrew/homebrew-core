class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/ce/43/d5e49a86afa64bd3839ea0d5b9c7103487007d728e1293f52525d6d5486a/mypy-1.15.0.tar.gz"
  sha256 "404534629d51d3efea5c800ee7c42b72a6554d6c400e6a79eafe15d11341fd43"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47a46cf281316caa47a3c03130a1dbb302bf9c4b744300d848ebb98e31b936f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ed30d04ea17719cff0a7a43dc8f2c038c3e776c1cadf97936203787bb63360d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60f43861fad3cb704383a97d5ce98829b77a076afe2ba8c0129f7179f3590c6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e578864a81144771caffa814b3334c2fcedd2863a57ae170f02bc432743e6ce"
    sha256 cellar: :any_skip_relocation, ventura:       "492cdd65beec15229107beca1198e90a9c560138f8c749ddefc5539f392c5ed4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8765920d1c8270415ec11c3e121512cd97b497f1ba4277bae9a4fd053f91b87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eceba777bfcaf012dcf14739c7899fbfcf08c9b01369a019f0e3d662760db1c0"
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
    (testpath/"broken.py").write <<~PYTHON
      def p() -> None:
        print('hello')
      a = p()
    PYTHON
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output

    output = pipe_output("#{bin}/mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end
