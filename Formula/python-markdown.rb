class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/fd/d6/9eeda2f440ef798c8222b77d7355199345ce3477941d8a02a2024ccb9ed2/Markdown-3.3.3.tar.gz"
  sha256 "5d9f2b5ca24bc4c7a390d22323ca4bad200368612b5aaa7796babf971d2b2f18"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5c0eca089cf51f1a18fa14b08ef2e453940d216bd28c971c1e32c1d92dc924c8" => :big_sur
    sha256 "e15c00fbbc97ddc7727ed969fa6b66e39d14a0840c701a278cc7d936265b3820" => :arm64_big_sur
    sha256 "2a5f0bc6b8f4e8f8910b638ca9de6d78d1721c670a58b04e85843e486f91b321" => :catalina
    sha256 "800ed7fb5c992646e2f6486eeb369b41a35f38f6aa1b219f91535ebb7817b755" => :mojave
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
