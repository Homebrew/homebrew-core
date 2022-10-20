class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https://github.com/bennorth/literate-git"
  url "https://github.com/bennorth/literate-git/archive/v0.3.1.tar.gz"
  sha256 "f1dec77584236a5ab2bcee9169e16b5d976e83cd53d279512136bdc90b04940a"
  license "GPL-3.0-or-later"
  revision 12

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0494553acd4da03d39c78afc1aa6cb4bf15fd6bcd7047477fb6b33949d3e3948"
    sha256 cellar: :any,                 arm64_big_sur:  "eb4acde55eee94e64423348ad6be510d6914342aafdc73b484dcf174938cc2d6"
    sha256 cellar: :any,                 monterey:       "7306590698c9c18e5131ea46969b20300eefb444634e4b3a8f649d8d03838924"
    sha256 cellar: :any,                 big_sur:        "69c963635ce4ab7711856a7ee3e2e64d7604edbde1acc33383788923f04077f0"
    sha256 cellar: :any,                 catalina:       "a5c6e5cdf7c393f773c18ad3b0dc291f9902754a42f5b03b6ec6a82f9816ca98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45893bf099f2c666fa4e9db2e33831a398104626985298928f19652d4a6e39dc"
  end

  depends_on "libgit2"
  depends_on "python@3.10"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/2b/26/1dd47bdf8adb98e1807b2283a88d6d4379911a2e1a1da266739c038ef8e2/markdown2-2.4.3.tar.gz"
    sha256 "412520c7b6bba540c2c2067d6be3a523ab885703bf6a81d93963f848b55dfb9a"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/e7/8a/e52a1c8b9878e9d9743089393f8289bb9c8a81eaab722df22df46a38b9e9/pygit2-1.10.0.tar.gz"
    sha256 "7c751eee88c731b922e4e487ee287e2e40906b2bd32d0bfd2105947f63e867de"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/cb/9f/27d4844ac5bf158a33900dbad7985951e2910397998e85712da03ce125f0/Pygments-2.5.2.tar.gz"
    sha256 "98c8aa5a9f778fcd1026a17361ddaf7330d1b7c62ae97c3bb0ae73e0b9b6b0fe"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    (testpath/"foo.txt").write "Hello"
    system "git", "add", "foo.txt"
    system "git", "commit", "-m", "foo"
    system "git", "branch", "one"
    (testpath/"bar.txt").write "World"
    system "git", "add", "bar.txt"
    system "git", "commit", "-m", "bar"
    system "git", "branch", "two"
    (testpath/"create_url.py").write <<~EOS
      class CreateUrl:
        @staticmethod
        def result_url(sha1):
          return ''
        @staticmethod
        def source_url(sha1):
          return ''
    EOS
    assert_match "<!DOCTYPE html>",
      shell_output("git literate-render test one two create_url.CreateUrl")
  end
end
