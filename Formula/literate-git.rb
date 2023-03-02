class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https://github.com/bennorth/literate-git"
  url "https://github.com/bennorth/literate-git/archive/v0.3.1.tar.gz"
  sha256 "f1dec77584236a5ab2bcee9169e16b5d976e83cd53d279512136bdc90b04940a"
  license "GPL-3.0-or-later"
  revision 13

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "7123f185fcb67750d608444ace1c1d42f8daa95d38ad4fb54a9956b80a68a093"
    sha256 cellar: :any,                 arm64_monterey: "3a7efd54ea8c6ebe7532d80d27c3a57ead8e5a7a37080b8835f9f53fc5a236c3"
    sha256 cellar: :any,                 arm64_big_sur:  "ae83e8814a3fe639b27dfd08b25b786d374dc443757d28d7e8f3dc46a1dfaf5c"
    sha256 cellar: :any,                 ventura:        "e60d2a921b591c910e204ef52f4fbfec8858372b902b3680d2bfe257d75a6823"
    sha256 cellar: :any,                 monterey:       "faa2db260d7704d414f9b638be400c221f11f370625f517fd37d1a5ceddccb0e"
    sha256 cellar: :any,                 big_sur:        "ad57d1c032134f51601e44dcdf1699d3d96c360a1227a4b753c083112a6a7957"
    sha256 cellar: :any,                 catalina:       "7ffed81f6a33a292fc4b51a9bd55dad33a3a76f527dbddf6401962452f55833c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98d3ffe8420023a305071c7aa26a38f5a3c3e1f050ecd7ab127203973a0cb759"
  end

  depends_on "pygit2"
  depends_on "python@3.11"

  on_linux do
    depends_on "pkg-config" => :build
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
