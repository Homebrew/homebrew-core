class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/85/7e/133e943e97a943d2f1d8bae0c5060f8ac50e6691754eb9dbe036b047a9bb/Markdown-3.4.1.tar.gz"
  sha256 "3b809086bb6efad416156e00a0da66fe47618a5d6918dd688f53f40c8e4cfeff"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3237d2dbf41e0291bef1fcc02d194d76706ca8db670386d9d1736f3f2271ceea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f41ee4085d159af4cbd5a51fc12290dd682a7b6fba59398d9702f4519cb09529"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7644ec48efb17d9a826aba4aacfdb08ce5bba49b24daf8006f1ef697aa46f86e"
    sha256 cellar: :any_skip_relocation, monterey:       "3eabeee2e6c92e05e8b6022103c3f52ad6892ab9a76427e027997101befe1b57"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cbfab72f7a57af0433d1fcaa0e8c7be91d76db59f456c5b684c25fe9ae1eb9a"
    sha256 cellar: :any_skip_relocation, catalina:       "47b4e7d7aabf71c2c879d855773ed72fab2e31bac5b3cdf65010f300d0b70b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf60875a580a8446afa3d4c7d95f4bb9811fbb39ce61890cd2703d6558802f7f"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip
  end
end
