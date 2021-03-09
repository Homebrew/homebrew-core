class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/78/b1/6079ca9a5afbedb663a0c3db82bd2bcba1574ccdb55acd9b9855ed79dd39/mypy-0.812.tar.gz"
  sha256 "cd07039aa5df222037005b08fbbfd69b3ab0b0bd7a07d7906de75ae52c4e3119"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a72404960416f689a3bfc70537b28deccf6003d937fc0f2ccbf5ef66ccc1f887"
    sha256 cellar: :any_skip_relocation, big_sur:       "f91d5b4cdf147bf3842a8206085890ef07e2bc0e9a4ca9ea7e15e06d29efb823"
    sha256 cellar: :any_skip_relocation, catalina:      "98e78ca77339a90caf679b561547e83c169078c1b5b1e90e024b4b8b1ac26055"
    sha256 cellar: :any_skip_relocation, mojave:        "c03ea7bef371f9a3b5c0afa271126bde84e4713461e20ff179e5dbb654b94740"
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
