class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/73/ef/a3b56028305971a7130992702097e6cde5dcfa2ee01fd5f0d66880cce012/mypy-0.950.tar.gz"
  sha256 "1b333cfbca1762ff15808a0ef4f71b5d3eed8528b23ea1c3fb50543c867d68de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82f478c83c0b50fe31ac6dcb8bb7803c27f4e0cde18f5390fc73b2be50b92c55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "953303d154b2be96fe6de484fb21c406a9a7428deb8349c7777e889757559309"
    sha256 cellar: :any_skip_relocation, monterey:       "fa73d73a9f3dac9b589d5f20ca2f4aa2b7bc83fb3630513e8d813d2c4de173bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6ccb11a8baadd2f4c14ffac76ca9e7caf939df880ec613f902165d1217c7771"
    sha256 cellar: :any_skip_relocation, catalina:       "132d0584790faaeb8a553d1aa3fb4f11e97f65c23db4009d9c61c8c146157b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6759d1d06bb5b97f24a52820a898abb5db88d8095ad978f69813dfbc1c72988f"
  end

  depends_on "python@3.10"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/fe/71/1df93bd59163c8084d812d166c907639646e8aac72886d563851b966bf18/typing_extensions-4.2.0.tar.gz"
    sha256 "f1c24655a0da0d1b67f07e17a5e6b2a105894e6824b92096378bb3668ef02376"
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
