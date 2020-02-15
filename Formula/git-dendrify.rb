class GitDendrify < Formula
  include Language::Python::Virtualenv

  desc "Transform git histories between tree-like and linear forms"
  homepage "https://github.com/bennorth/git-dendrify"
  url "https://github.com/bennorth/git-dendrify/archive/v0.2.0.tar.gz"
  sha256 "46c30d34e2fb1f26761ad34f361179334a650bddd853b9aec17ec5c4ab7fdee2"
  head "https://github.com/bennorth/git-dendrify.git"

  depends_on "python"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/05/54/3324b0c46340c31b909fcec598696aaec7ddc8c18a63f2db352562d3354c/cffi-1.14.0.tar.gz"
    sha256 "2d384f4a127a15ba701207f7639d94106693b6cd64173d6c8988e2c25f3ac2b6"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/cd/18/c674c9389aef8c940393e0507f9fe9437efd8e56ff1efa837d3fbfcd1d42/pygit2-1.0.3.tar.gz"
    sha256 "de6c170dc09878e98424430ed6ba2934c01d811fedbc4cdfd71ec1dcd98487e2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "\"</s>one\""
    system "git", "branch", "start"
    (testpath/"foo.txt").write "Hello"
    system "git", "add", "foo.txt"
    system "git", "commit", "-m", "two"
    (testpath/"bar.txt").write "World"
    system "git", "add", "bar.txt"
    system "git", "commit", "-m", "\"<s>three\""
    system "git", "branch", "end"
    assert_match /two/,
      shell_output("git dendrify dendrify dendrified start end")
  end
end
