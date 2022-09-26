class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/98/d1/39861ecddba2616663f3cb52920fd70c465867b8cfe858d377fac0dd1b4b/mypy-0.981.tar.gz"
  sha256 "ad77c13037d3402fbeffda07d51e3f228ba078d1c7096a73759c9419ea031bf4"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4e92d39703c8e5f2af38ff603e525dbbbdfe9fd7f0a269e80934ae8efb26a8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "791b7baab9917ce5ae01a91dc692beef801133aa89d928bb7cd36eb6d2027a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "929f59cbdf068995a3caa9b52d241c76abd2bcf030ca3556da42ba65ca6dae20"
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
    url "https://files.pythonhosted.org/packages/9e/1d/d128169ff58c501059330f1ad96ed62b79114a2eb30b8238af63a2e27f70/typing_extensions-4.3.0.tar.gz"
    sha256 "e6d2677a32f47fc7eb2795db1dd15c1f34eff616bcaf2cfb5e997f854fa1c4a6"
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
