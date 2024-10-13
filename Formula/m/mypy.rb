class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/5c/86/5d7cbc4974fd564550b80fbb8103c05501ea11aa7835edf3351d90095896/mypy-1.11.2.tar.gz"
  sha256 "7f9993ad3e0ffdc95c2a14b66dee63729f021968bff8ad911867579c65d13a79"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8ba2b491e762e6c0e640b555fde8dcc3b4513041c41a759ca64da448ab1da933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "613375bbea6b54c0a7d64088b92ec9f5c8f31b6aaf360741f65ccbb76628b5a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cfe1c4d8f25ecf3e01355957a6d0d598334e9384b6700c3d48a2ce293e32f7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f68bbcbd40d268be1e9310dee8f27f20929e3bc9a76f07f249453d83c23c5ab8"
    sha256 cellar: :any_skip_relocation, sonoma:         "5202da3b0e520593010a9280a6295125cb6e4a52b051fd6f3a83d34dc92b37d5"
    sha256 cellar: :any_skip_relocation, ventura:        "9d8a5ff6ce1395df6e4f455b3b6ce8bc468bc58d33f807e6ea2f69fd9149e5a1"
    sha256 cellar: :any_skip_relocation, monterey:       "2b8c44574ca730eb74573e52695cde0bc805f3f4c45d134cf16e6ba35e7c6219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fc5c7dd102eb6f22660025e06c272a5189c01ce14a3c3c260fedfbf8c45ad2c"
  end

  depends_on "python@3.12"

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
