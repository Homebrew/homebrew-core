class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "https://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/33/f9/c84b68e4a754f5ce200dcf0786aa489164fa9d9dee84e375bd7d99caf637/mypy-1.5.1.tar.gz"
  sha256 "b031b9601f1060bf1281feab89697324726ba0c0bae9d7cd7ab4b690940f0b92"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1797f1a1b80be4c16bb22d7c49c10ec205219bd83052381e18241a5b5bb1553d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dc821b22266c1522813fbf75e35f5674f2ab1e984828ac3da1ef377b8c28f80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dfcdca78246785e24c2a4a58244ffe2239dea1f20e3a0c969a408d052db0ae1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b31bcc926d4c6d2fad92f55c4a14737491093fecbf6c9ca26138130f5316f4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "838ed241a56ad88bb9c606d85f90eee31ef4a38f95ffeb9aa47a24bef009b476"
    sha256 cellar: :any_skip_relocation, ventura:        "2c38ceb8c85948f6ddfabbbc21418abd524e1c8f4bd865fca3359343288c968e"
    sha256 cellar: :any_skip_relocation, monterey:       "966e10ed6cebf2dcf0990c3415dcee588a2f5257f4a08fca9e26430e4f894af4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f49347812a7031ddfa56ede0f26aa57639ffe00c1cd0e0e063282eef9a145c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5adf4d8804a600407932288d7f6afeb8a7c3bce5159f46bcfc0ade0df6f1a105"
  end

  depends_on "python@3.11"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  # The `python-typing-extensions` formula depends on `mypy`, so we use a resource here instead
  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/3c/8b/0111dd7d6c1478bf83baa1cab85c686426c7a6274119aceb2bd9d35395ad/typing_extensions-4.7.1.tar.gz"
    sha256 "b75ddc264f0ba5615db7ba217daeb99701ad295353c45f9e95963337ceeeffb2"
  end

  def install
    ENV["MYPY_USE_MYPYC"] = "1"
    ENV["MYPYC_OPT_LEVEL"] = "3"
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

    output = pipe_output("#{bin}/mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end
