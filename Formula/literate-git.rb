class LiterateGit < Formula
  include Language::Python::Virtualenv

  desc "Render hierarchical git repositories into HTML"
  homepage "https://github.com/bennorth/literate-git"
  url "https://github.com/bennorth/literate-git/archive/v0.3.1.tar.gz"
  sha256 "f1dec77584236a5ab2bcee9169e16b5d976e83cd53d279512136bdc90b04940a"
  license "GPL-3.0-or-later"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "70de9fa226a134261458d9444d3d7f437904b24081a9ed6aca3140eb9870c21a"
    sha256 cellar: :any,                 arm64_big_sur:  "864bf8824b30cc890fd2ba1485c543b09407cba676b375ffe10de06636d1bf27"
    sha256 cellar: :any,                 monterey:       "a96e4e1c9fd655b13bf7839f9ba9364a0309b42e13f42117c8d71df98a8a51ef"
    sha256 cellar: :any,                 big_sur:        "35f3d2668258e32f9ac4a9de9c71a000e62c22f7efbd20b1c88f94cdccf56cce"
    sha256 cellar: :any,                 catalina:       "43b13a04effc70753f1fa7fdc02fcee8ba8c0c849a4e361668bf11a6a29734be"
    sha256 cellar: :any,                 mojave:         "fe23dd09f5d14c453b79c3db3d507d8b9b2c4896fb28602add1f3f45bff49960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a0de736b319754e0b70c53a0230714c8fca626cca818d0b54e0739a7e49944a"
  end

  depends_on "libgit2"
  depends_on "python@3.10"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/57/8e/0698e10350a57d46b3bcfe8eff1d4181642fd1724073336079cb13c5cf7f/cached-property-1.5.1.tar.gz"
    sha256 "9217a59f14a5682da7c4b8829deadbfc194ac22e9908ccf7c8820234e80a1504"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/66/6a/98e023b3d11537a5521902ac6b50db470c826c682be6a8c661549cb7717a/cffi-1.14.4.tar.gz"
    sha256 "1a465cbe98a7fd391d47dce4b8f7e5b921e6cd805ef421d04f5f66ba8f06086c"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/d8/03/e491f423379ea14bb3a02a5238507f7d446de639b623187bccc111fbecdf/Jinja2-2.11.1.tar.gz"
    sha256 "93187ffbc7808079673ef52771baa950426fd664d3aad1d0fa3e95644360e250"
  end

  resource "markdown2" do
    url "https://files.pythonhosted.org/packages/e3/93/d37055743009d1a492b2670cc215831a388b3d6e4a28b7672fdf0f7854f5/markdown2-2.3.8.tar.gz"
    sha256 "7ff88e00b396c02c8e1ecd8d176cfa418fb01fe81234dcea77803e7ce4f05dbe"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/6b/23/a8c5b726a58282fe2cadcc63faaddd4be147c3c8e0bd38b233114adf98fd/pygit2-1.6.1.tar.gz"
    sha256 "c3303776f774d3e0115c1c4f6e1fc35470d15f113a7ae9401a0b90acfa1661ac"

    # libgit2 1.3 support
    # https://github.com/libgit2/pygit2/pull/1089
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/54d3a0d1f241fdd4e9229312ced0d8da85d964b1/pygit2/libgit2-1.3.0.patch"
      sha256 "4d501c09d6642d50d89a1a4d691980e3a4a2ebcb6de7b45d22cce16a451b9839"
    end
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
