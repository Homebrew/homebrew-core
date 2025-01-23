class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/b9/eb/2c92d8ea1e684440f54fa49ac5d9a5f19967b7b472a281f419e69a8d228e/mypy-1.14.1.tar.gz"
  sha256 "7ec88144fe9b510e8475ec2f5f251992690fcf89ccb4500b214b4226abcd32d6"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d903e151f7865ca93dcf172851740a8806078af17afc47bab85b119b727cc949"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45e0169fb4aa0e9a3fb5185c074f245eb082c57fdde7926effeca12f26d9c471"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49d1641cb533afb31275024f8aea57e8e11cfa7e8395cfd2607d02d05faad807"
    sha256 cellar: :any_skip_relocation, sonoma:        "44d89427386a0490417caec99663e98e0904a05521261d4554bbdb52e3964222"
    sha256 cellar: :any_skip_relocation, ventura:       "7d35b440114870b7882e03fa39a0300af16c0a35f6ff712c544d98eafe15c313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a591b3626f739da700de92d45d9c0a51f2a9973b7b738b3cf1df49a34fc46d7b"
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
