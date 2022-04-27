class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/73/ef/a3b56028305971a7130992702097e6cde5dcfa2ee01fd5f0d66880cce012/mypy-0.950.tar.gz"
  sha256 "1b333cfbca1762ff15808a0ef4f71b5d3eed8528b23ea1c3fb50543c867d68de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6da20c53f768f86a98b3f44663ab57a89f02f57fd72703f157d952b3ee72f563"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a1106c8dbeeb9f9386e7133ee079a3542b535a057f65938502406aa6d4232eb"
    sha256 cellar: :any_skip_relocation, monterey:       "be550539b724ebc1df677ea9760c929159fe698d8a313c41bf6f92360d26892b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e928518c1889b1bedc242135c18f3b94460959b5f9a4a23c6423572f114f287c"
    sha256 cellar: :any_skip_relocation, catalina:       "e24f0562537a5729d21c1dcc42233d12b9c6f9d5c96038c762929a18a54267cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9966b917abab81ab34166bb86ad6b4897614103f768a7b05a8c4f3b734cc7312"
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
