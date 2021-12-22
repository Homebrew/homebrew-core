class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/8e/79/116f9828cfb88904c94640c683ca1f24d9abc89c688e31d436eba82e09a1/mypy-0.930.tar.gz"
  sha256 "51426262ae4714cc7dd5439814676e0992b55bcc0f6514eccb4cf8e0678962c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ffea4e7990be354591e7df0f90c2a3292b11f71ab92017e24f6b0f4db6b3fad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbdfe274f70e0c8066af7ad9d8d5ac4fd65e3d50a0f3a24aaea364e42b04060a"
    sha256 cellar: :any_skip_relocation, monterey:       "a7c12f8099678183d7506473cac4847b6f8b283fb3dbf9729ad66e0f32de139d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2f3f8ab1b876833594f97d69652d537e91243c1d584667576d4f0c71f9db28e"
    sha256 cellar: :any_skip_relocation, catalina:       "32853f955883fa054727d0c5492f66b4699593d3ab18b858f24d9b53a3416c99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39db9125f1bb6d9760bbb5e41364c9ca7de245468993ac051ef21ac869b82600"
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
