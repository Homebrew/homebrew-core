class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://pypi.python.org/pypi/Markdown"
  url "https://github.com/Python-Markdown/markdown/archive/3.3.3.tar.gz"
  sha256 "45cd8917edfc46a24ad9203d8f13a6b7032a9e109afc0a944dbde8e25a7f0eeb"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0f1acd3bade5dcf20e55f1f529466661431837db545e7eb2ef8e66f61a528fe2" => :big_sur
    sha256 "7f270600b53d2b1aefe29154c16ca306b772b39f6d377ae7d82ae20425059545" => :catalina
    sha256 "405c7b2f8a352431037b0bd826a27860048802d64ebe358784a90e89c49fe96f" => :mojave
    sha256 "c3ae8ee427fc9a6b2ac86dab378ec1b6b408e82022ebb6123a94c94e910b94fc" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip
  end
end
