class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/80/5b/8b3ed91920fe20ffa4b6473966b4a98e9759f7245e2232faf29c6c56d150/mypy-0.800.tar.gz"
  sha256 "e0202e37756ed09daf4b0ba64ad2c245d357659e014c3f51d8cd0681ba66940a"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bb60227c0abf74657de3f527793816c2dda2e466c9882711d32108574cf85339"
    sha256 cellar: :any_skip_relocation, big_sur:       "c8ce5ece63124e9426eee5fdb666af203fb687ed85e42802da5256b9410f3f28"
    sha256 cellar: :any_skip_relocation, catalina:      "b6ffae696bf452d07de1f017810fa9beeac4ca49a33528a6dbedef2f7c73f27c"
    sha256 cellar: :any_skip_relocation, mojave:        "949b53af966482d5e6949e75553531b3deff7eace6ce4c07193c7673acf6d167"
  end

  depends_on "python@3.9"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "typed-ast" do
    url "https://files.pythonhosted.org/packages/36/8c/efd8ffe7d242cd389632a11cbc6ce596de49b46ece22760a67b742534368/typed_ast-1.4.2.tar.gz"
    sha256 "9fc0b3cb5d1720e7141d103cf4819aea239f7d136acf9ee4a69b047b7986175a"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/06/0f7367eafb692f73158e5c5cbca1aec798cdf78be5167f6415dd4205fa32/typing_extensions-3.7.4.3.tar.gz"
    sha256 "99d4073b617d30288f569d3f13d2bd7548c3a7e4c8de87db09a9d29bb3a4a60c"
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
