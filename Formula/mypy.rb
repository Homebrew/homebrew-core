class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/4e/a2/686871fae023daa8c2ac04f01c4a4c730761561adf25cf7a997f10899f44/mypy-0.921.tar.gz"
  sha256 "eca089d7053dff45d6dcd5bf67f1cabc311591e85d378917d97363e7c13da088"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7939ca24782636917e5d501aa072d39169a08ee53b1ca63b2150f24168a22b18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3700b827f6498535c7cfdf57d30130a4338ea0fbd955df1c54eca5b6d55b86e9"
    sha256 cellar: :any_skip_relocation, monterey:       "eed8104830fa1897fe047ad9bcd09e29372695df58b8ad1367e079e340864862"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6d1bea31d7dbe327a3bf4c73bb85b4afdb1f8079e87218418e6009acdc0155c"
    sha256 cellar: :any_skip_relocation, catalina:       "e1dd2e8790e20d06ab5569442b63659683aaf9e76ff6d88b01912aab82987ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4926a5862aa938d6db8bd3e6eff09155ac9611b220c9e456e950cb577565aad"
  end

  depends_on "python@3.10"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/3d/6e/d290c9bf16159f02b70c432386aa5bfe22c2857ff460591912fd907b61f6/tomli-2.0.0.tar.gz"
    sha256 "c292c34f58502a1eb2bbb9f5bbc9a5ebc37bee10ffb8c2d6bbdfa8eb13cc14e1"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0d/4a/60ba3706797b878016f16edc5fbaf1e222109e38d0fa4d7d9312cb53f8dd/typing_extensions-4.0.1.tar.gz"
    sha256 "4ca091dea149f945ec56afb48dae714f21e8692ef22a395223bcd328961b6a0e"
  end

  def install
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
  end
end
