class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/67/48/e73045183ce9824d98365f18255a79d0b01638f40a0a68f898dc8f3cebcc/mypy-0.961.tar.gz"
  sha256 "f730d56cb924d371c26b8eaddeea3cc07d78ff51c521c6d04899ac6904b75492"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ecd86843ab85b0ba19443d99bdc52d5aba5868bdac6bb63179cfecf3a4db7ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4983ef5671a629912e09c902b1f197b2188cc06d196db71fed03f2b49371e26"
    sha256 cellar: :any_skip_relocation, monterey:       "d6bc488b635dc2de5240e7f6dd1780eec240469acf11005cd495b1729c766c99"
    sha256 cellar: :any_skip_relocation, big_sur:        "0329aa393ee537015bf9c596b449ed351d53830b7d48db4babe3826e3a3474b6"
    sha256 cellar: :any_skip_relocation, catalina:       "22645773981672929c2aba26cd10b3cbda3e4e50ece950559022eefd879325c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65d4ddc2193fee907d723dbc3a165723c5606fd40e3a6abafeeb5ebcc66ea4ab"
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
