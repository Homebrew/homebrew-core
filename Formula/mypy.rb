class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/4b/b2/9c71fd84086e96518b1d7a940788d704d3a67aead3e3a7ff9bf8e9b5746d/mypy-0.931.tar.gz"
  sha256 "0038b21890867793581e4cb0d810829f5fd4441aa75796b53033af3aa30430ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19560f740bae822c5b5a6430538aa9f14399749cbb465d786e8cee1915e2bbc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5313ed2cd5b3b4396993eed603759c32f23dc826a01855d26af002bb06345e5b"
    sha256 cellar: :any_skip_relocation, monterey:       "f46562646480761daa5f8ef749346dbb013cac158bd73503b60e6624d3de9e59"
    sha256 cellar: :any_skip_relocation, big_sur:        "24e64862e3f6ac8372365d23b4b89921e00b36dfb3a7a4c1635b0eef6ed4b019"
    sha256 cellar: :any_skip_relocation, catalina:       "cf3dc1cc55d2e29d1c3956d7a2111bd589d441d8c44b257666ffe35b0bec212a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da3ec090ece5e64e988d5a8d8a4937a17f3a4521404a304734d825c3c90305c8"
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
