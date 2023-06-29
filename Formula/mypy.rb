class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/b3/28/d8a8233ff167d06108e53b7aefb4a8d7350adbbf9d7abd980f17fdb7a3a6/mypy-1.4.1.tar.gz"
  sha256 "9bbcd9ab8ea1f2e1c8031c21445b511442cc45c89951e49bbf852cbb70755b1b"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15765f71587eb6705a1c86031cfdc66e1dea7899808686ba39a391c9b811cf8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96d0c6ffe40df9953725498d8ef83c495815fd52044f7cde1574e5dab8c8aa58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f232cf3bf397483e5979ee6fc8bc8b40045ac9a85b5a12b571b6c11b9921e95"
    sha256 cellar: :any_skip_relocation, ventura:        "59dc4c1166f46e36c72bd529f89d5f07b3b31d8f51ac3befb8ebe79042704b81"
    sha256 cellar: :any_skip_relocation, monterey:       "087f63937a3f02b9a80b04f64de9ccd2690e2012db11226777323ef70908070e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3bbceeaf62813dbe3723b0117182c57d568e476d94d9d5352d2436dea122f64a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa38b21fd472b462f3255b12c515b981b6874d5aed1eb0cf75a8854ad09718b7"
  end

  depends_on "python@3.11"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  # The `python-typing-extensions` formula depends on `mypy`, so we use a resource here instead
  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/42/56/cfaa7a5281734dadc842f3a22e50447c675a1c5a5b9f6ad8a07b467bffe7/typing_extensions-4.6.3.tar.gz"
    sha256 "d91d5919357fe7f681a9f2b5b4cb2a5f1ef0a1e9f59c4d8ff0d3491e05c0ffd5"
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
