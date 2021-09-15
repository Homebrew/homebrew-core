class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/49/02/37bd82ae255bb4dfef97a4b32d95906187b7a7a74970761fca1360c4ba22/Markdown-3.3.4.tar.gz"
  sha256 "31b5b491868dcc87d6c24b7e3d19a0d730d59d3e46f4eea6430a321bed387a49"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "43873534a708de73d549d2c4d0bc5b9bd096f3f1e75ea3e143aa82925ef3e6f2"
    sha256 cellar: :any_skip_relocation, big_sur:       "b4ef9a4f29b3c51b03907e50b89b0a9ef7f2a87951c624956beba0e1627f4618"
    sha256 cellar: :any_skip_relocation, catalina:      "689b8240e4c6c352ba8d00bbb736a4e0bfa9854a4ab3b741231df6dc670a172f"
    sha256 cellar: :any_skip_relocation, mojave:        "aefbd3f47aa88aadf990c0d3ae108da38a89cdbab7cf7bcfd1e81eadbca06340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b513443497e90f6932d03abce5d7c186a02478ba7700c730798dde2973aa1dd6"
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
