class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/4b/b2/9c71fd84086e96518b1d7a940788d704d3a67aead3e3a7ff9bf8e9b5746d/mypy-0.931.tar.gz"
  sha256 "0038b21890867793581e4cb0d810829f5fd4441aa75796b53033af3aa30430ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "169532441d1185d7da8ad3caa6d4d0dcb6f6cae01743a434b8bd7f9878ab6385"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf942a73d60680a00bd1a890b494fb3c459e1b72bc3b79886acc0e873f572768"
    sha256 cellar: :any_skip_relocation, monterey:       "16ac6406fa0d1102ef1517fb82d0e69a4c2c23a8a285ae1821e74b9e305bf74b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b5a2f66d9f1dd4e4931af4bc6b55560ed9fb5d9c8098c84b33c06ef1966b846"
    sha256 cellar: :any_skip_relocation, catalina:       "07d0521f5d819d9a65ecc0aaec9934198cfc59aa7f86253d22af96abc8d7b1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38726922fc8ee6af53e6d039bed8bf9eaf581161f7f31aaca9bb712754ed91d7"
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
