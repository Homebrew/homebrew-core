class Pycodestyle < Formula
  include Language::Python::Shebang

  desc "Simple Python style checker in one Python file"
  homepage "https://pycodestyle.pycqa.org/"
  url "https://github.com/PyCQA/pycodestyle/archive/2.11.0.tar.gz"
  sha256 "757a3dba55dce2ae8b01fe7b46c20cd1e4c0fe794fe6119bce66b942f35e2db0"
  license "MIT"
  head "https://github.com/PyCQA/pycodestyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccdf2b3074573d89f9e79789cf9eecc15c8c29bba245a026333a0f8410efae45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccdf2b3074573d89f9e79789cf9eecc15c8c29bba245a026333a0f8410efae45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccdf2b3074573d89f9e79789cf9eecc15c8c29bba245a026333a0f8410efae45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccdf2b3074573d89f9e79789cf9eecc15c8c29bba245a026333a0f8410efae45"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccdf2b3074573d89f9e79789cf9eecc15c8c29bba245a026333a0f8410efae45"
    sha256 cellar: :any_skip_relocation, ventura:        "ccdf2b3074573d89f9e79789cf9eecc15c8c29bba245a026333a0f8410efae45"
    sha256 cellar: :any_skip_relocation, monterey:       "ccdf2b3074573d89f9e79789cf9eecc15c8c29bba245a026333a0f8410efae45"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccdf2b3074573d89f9e79789cf9eecc15c8c29bba245a026333a0f8410efae45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfb848219694c3d5ab9095b5817e40b54cddd926bd48b34c7463161e9f4e27c7"
  end

  depends_on "python@3.11"

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
