class Pycodestyle < Formula
  include Language::Python::Shebang

  desc "Simple Python style checker in one Python file"
  homepage "https://pycodestyle.pycqa.org/"
  url "https://github.com/PyCQA/pycodestyle/archive/refs/tags/2.12.0.tar.gz"
  sha256 "c72dccf2bf7ceb603b5bd8b737a511d5241e675e90d4f75bc8a12fe81f24c094"
  license "MIT"
  head "https://github.com/PyCQA/pycodestyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3dcf668f52752b5bf2e97e0fd2d1e42dc2889c1b9e62fe2a36727d8156d221fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dcf668f52752b5bf2e97e0fd2d1e42dc2889c1b9e62fe2a36727d8156d221fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dcf668f52752b5bf2e97e0fd2d1e42dc2889c1b9e62fe2a36727d8156d221fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dcf668f52752b5bf2e97e0fd2d1e42dc2889c1b9e62fe2a36727d8156d221fb"
    sha256 cellar: :any_skip_relocation, ventura:        "3dcf668f52752b5bf2e97e0fd2d1e42dc2889c1b9e62fe2a36727d8156d221fb"
    sha256 cellar: :any_skip_relocation, monterey:       "3dcf668f52752b5bf2e97e0fd2d1e42dc2889c1b9e62fe2a36727d8156d221fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a44ef22a22f8a40ece9db61bf4447a5c68c192f042718cbf07fdcd8ebb202777"
  end

  depends_on "python@3.12"

  def install
    rewrite_shebang detected_python_shebang, "pycodestyle.py"
    bin.install "pycodestyle.py" => "pycodestyle"
  end

  test do
    # test invocation on a file with no issues
    (testpath/"ok.py").write <<~EOS
      print(1)
    EOS
    assert_equal "",
      shell_output("#{bin}/pycodestyle ok.py")

    # test invocation on a file with a whitespace style issue
    (testpath/"ws.py").write <<~EOS
      print( 1)
    EOS
    assert_equal "ws.py:1:7: E201 whitespace after '('\n",
      shell_output("#{bin}/pycodestyle ws.py", 1)

    # test invocation on a file with an import not at top of file
    (testpath/"imp.py").write <<~EOS
      pass
      import sys
    EOS
    assert_equal "imp.py:2:1: E402 module level import not at top of file\n",
      shell_output("#{bin}/pycodestyle imp.py", 1)
  end
end
