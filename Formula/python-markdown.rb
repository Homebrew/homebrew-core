class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://pypi.python.org/pypi/Markdown"
  url "https://github.com/Python-Markdown/markdown/archive/3.3.1.tar.gz"
  sha256 "5edc04d4afa4b4a6859f50d73c5e64bb4a1b5f44debe26398ee0f1040b0635a6"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "86fdb3082a32df892f8344100929795de8aba2dac965677b0c7e7b6a4470729a" => :catalina
    sha256 "80e595735252ab2d6ec6059bad7e4b1a976b5fd1ba11f8c28fad977c68ccf032" => :mojave
    sha256 "a4fc3011403266446e0507eaa930908ba864b2fe199b7abb6bb14ecdaa81855d" => :high_sierra
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
