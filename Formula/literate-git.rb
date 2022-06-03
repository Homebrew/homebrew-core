class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https://github.com/bennorth/literate-git"
  url "https://github.com/bennorth/literate-git/archive/v0.3.1.tar.gz"
  sha256 "f1dec77584236a5ab2bcee9169e16b5d976e83cd53d279512136bdc90b04940a"
  license "GPL-3.0-or-later"
  revision 11

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c2031c7652e019684c8a4fe2e4002df04a6026c12cbb39f8590283094d0f26f3"
    sha256 cellar: :any,                 arm64_big_sur:  "b331d1904320a141a66c84a3995671a33215bc27ed0843ed841ea00083ef505b"
    sha256 cellar: :any,                 monterey:       "cc84a4cdf421f1a5295ded1b57b7b44c51ed95b7488c539c8cb5c579b27f1153"
    sha256 cellar: :any,                 big_sur:        "ec1b9726828e6759864d461fcc8feadc4df90d6739aa8571a3d7e4d931bc31d1"
    sha256 cellar: :any,                 catalina:       "baa921185d969af27ffda77668f241a8a60c36f11bcaa8d3e054e3429eb732ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e46878c8fd6fb42c5689456331292833ab9bff08bf2a035a872760cd9250d41d"
  end

  depends_on "libgit2"
  depends_on "python@3.10"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
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
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/15/69/95baec94618352fad36a5c53ed1a7a96f7de96d2b36c5ac3fc2a5017b78a/pygit2-1.9.2.tar.gz"
    sha256 "20894433df1146481aacae37e2b0f3bbbfdea026db2f55061170bd9823e40b19"
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
