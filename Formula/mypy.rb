class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/80/5b/8b3ed91920fe20ffa4b6473966b4a98e9759f7245e2232faf29c6c56d150/mypy-0.800.tar.gz"
  sha256 "e0202e37756ed09daf4b0ba64ad2c245d357659e014c3f51d8cd0681ba66940a"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d20a5070532554fc32a9026ac16ca1fe9e9018dea5cf575d4dfe807b48ab2f51"
    sha256 cellar: :any_skip_relocation, big_sur:       "6e9266f07abbef368e3c726be5702130ebf352a29947d8b7ce203fe06ff218d8"
    sha256 cellar: :any_skip_relocation, catalina:      "bce213cfa9fa83b894ab9a335d844dd0040842a89955b8a37a4e3f76326349f6"
    sha256 cellar: :any_skip_relocation, mojave:        "92769fc27906e2a28857a33a7e55918b129123659dfb27b35e8cbb2ea2d41f32"
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
