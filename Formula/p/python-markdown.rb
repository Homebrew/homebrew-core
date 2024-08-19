class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/54/28/3af612670f82f4c056911fbbbb42760255801b3068c48de792d354ff4472/markdown-3.7.tar.gz"
  sha256 "2ae2471477cfd02dbbf038d5d9bc226d40def84b4fe2986e49b59b6b472bbed2"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "616c2b362eb1ceb49e0d1e21d1725dd6b40bf9c6a36b4fa03942bdb57ea7cb28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "616c2b362eb1ceb49e0d1e21d1725dd6b40bf9c6a36b4fa03942bdb57ea7cb28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "616c2b362eb1ceb49e0d1e21d1725dd6b40bf9c6a36b4fa03942bdb57ea7cb28"
    sha256 cellar: :any_skip_relocation, sonoma:         "616c2b362eb1ceb49e0d1e21d1725dd6b40bf9c6a36b4fa03942bdb57ea7cb28"
    sha256 cellar: :any_skip_relocation, ventura:        "616c2b362eb1ceb49e0d1e21d1725dd6b40bf9c6a36b4fa03942bdb57ea7cb28"
    sha256 cellar: :any_skip_relocation, monterey:       "616c2b362eb1ceb49e0d1e21d1725dd6b40bf9c6a36b4fa03942bdb57ea7cb28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d123ff5377049c5bc38d92cd1eaeb190c494f2b4feebe919da68914dc09fd446"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip
  end
end
