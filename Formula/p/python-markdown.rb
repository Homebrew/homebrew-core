class PythonMarkdown < Formula
  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/62/25/1b21a708e65a933e9e2ecf03bfc7fae7169981cc688155cdb581de3e86dc/Markdown-3.5.tar.gz"
  sha256 "a807eb2e4778d9156c8f07876c6e4d50b5494c5665c4834f67b06459dfd877b3"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90d3add1ec8c887fe271043bce02e27bd584f975f2f2494bb7f75184852181dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff8e1283c4a0a44eb4b2ecc74fc426387ed4a598e28ffc3235020a92257aacb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "093a299ac88e9c49dbae824f8eacebaaae0ae8493e84892077c7f6d43b13af40"
    sha256 cellar: :any_skip_relocation, sonoma:         "efdfb67f2f6b9b595490d4316bfe5862162d44748501d09691e84afffc4af251"
    sha256 cellar: :any_skip_relocation, ventura:        "b792d70caf2acce475189fb4d6bc0e6e3356cef795eacfff31795870a3661b19"
    sha256 cellar: :any_skip_relocation, monterey:       "418ec6dbab72167738de922bd548974939cdba7719eaa46fa5396058a118e767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aedd14d13709d3e5f7fc764bdc71a01a545aaf75a25280acd7094e3d33a07970"
  end

  depends_on "python@3.11"

  def python3
    which("python3.11")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip

    system python3, "-c", "import markdown;"
  end
end
