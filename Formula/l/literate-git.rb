class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https://github.com/bennorth/literate-git"
  url "https://github.com/bennorth/literate-git/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "f1dec77584236a5ab2bcee9169e16b5d976e83cd53d279512136bdc90b04940a"
  license "GPL-3.0-or-later"
  revision 14

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "182fd06d87ae8d2b804f46e1adc98d41ae376114d6792a1e76b1fd855e56f5cc"
    sha256 cellar: :any,                 arm64_ventura:  "9eac066a0c81de4339467ac7ff4925b36bdabb581af6ef3bd0e200e3d60915fe"
    sha256 cellar: :any,                 arm64_monterey: "58457ff10793ed67eec70cfe21005f2884d6704afc3a32619477b5c0aa4744d5"
    sha256 cellar: :any,                 sonoma:         "360e6555c5c5d44ce1629f76d6ca3907eac29ba2c5913578af86169b4ed2fe7b"
    sha256 cellar: :any,                 ventura:        "93660e96d1190869c285655d1baf5979ffc2d19664c18d58b73bf5b6deb7dc0f"
    sha256 cellar: :any,                 monterey:       "692439a95c1c2a0527caba8188eda61acc7b540ab4c7985fe0681e2c1cda48f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "280d7c2e724ef7e2deadbab95db97818a6818ec8fcef24713336790c3e4b0939"
  end

  depends_on "libgit2"
  depends_on "python@3.12"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/68/ce/95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91d/cffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/3c/e4/87a454674ac303e2ca6c25713845d2ae1b59c1a88576054cbec25aaebad1/markdown2-2.4.12.tar.gz"
    sha256 "1bc8692696954d597778e0e25713c14ca56d87992070dedd95c17eddaf709204"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/09/50/f0795db653ceda94f4388d2b40598c188aa4990715909fabcf16b381b843/pygit2-1.13.3.tar.gz"
    sha256 "0257c626011e4afb99bdb20875443f706f84201d4c92637f02215b98eac13ded"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/cb/9f/27d4844ac5bf158a33900dbad7985951e2910397998e85712da03ce125f0/Pygments-2.5.2.tar.gz"
    sha256 "98c8aa5a9f778fcd1026a17361ddaf7330d1b7c62ae97c3bb0ae73e0b9b6b0fe"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/fc/c9/b146ca195403e0182a374e0ea4dbc69136bad3cd55bc293df496d625d0f7/setuptools-69.0.3.tar.gz"
    sha256 "be1af57fc409f93647f2e8e4573a142ed38724b8cdd389706a867bb4efcf1e78"
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
