class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/52/56/afddb0a1654cf7f192419fbd9e46e01bceb11b1a6778a9d4257387f71dd8/mypy-1.0.1.tar.gz"
  sha256 "28cea5a6392bb43d266782983b5a4216c25544cd7d80be681a155ddcdafd152d"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a30b53ec14b75490fc5da91f1fe9e568580328469d71ad20c1f5bc81391988f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f59be1f67a878b27f0ffbf2991012cfc30092d01e1f21063ca2113325ef6142"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e98a1bd593d47324a96910e6fd4bc94dfac69c0f4e648ecad7fbcef113de5e5f"
    sha256 cellar: :any_skip_relocation, ventura:        "fa8f3048f48f3c0ab9cccc80e1bf847881a749caced499e59f072e1ff799729a"
    sha256 cellar: :any_skip_relocation, monterey:       "a134bb8a72aa87fbd78cce0d2412d2335e8341699b2fb7902ae68d2e9a849018"
    sha256 cellar: :any_skip_relocation, big_sur:        "249d2210d15e6ebf22810c8c3055a40c607ffc1cf68066e3e4240a497d8c5b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51aa3f4ca2d97e9be631b099faa3fa52a2122de31b3a46031aa5aed0ef93ac1e"
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
