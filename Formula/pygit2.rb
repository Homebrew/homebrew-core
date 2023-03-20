class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  # TODO: Check if we can use unversioned `libgit2` at version bump.
  url "https://files.pythonhosted.org/packages/43/9a/f4375f39d2de971750a7c16bd7ab9cc53368f395edaac59b32e9b3f62ce9/pygit2-1.11.1.tar.gz"
  sha256 "793f583fd33620f0ac38376db0f57768ef2922b89b459e75b1ac440377eb64ec"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  revision 1
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "47929ba416045e542761944af0d1457799674c0525d1734932f7dbd9affb89b9"
    sha256 cellar: :any,                 arm64_monterey: "dbaf76b5f73f823a4cc8f8cf999ae6504b269fbe3d95c72d1569606ff8a5a02d"
    sha256 cellar: :any,                 arm64_big_sur:  "65234a019f51e4f3a9ab17415e990a6d6f9623d6fad6bc8a88f67d1d6eb62178"
    sha256 cellar: :any,                 ventura:        "f0e519d768a3c03802e0f3c3305374c86606e78cf559628841415c161a235f67"
    sha256 cellar: :any,                 monterey:       "cf3ec15d1be822be858bd8a2b9e4b288217bc90a369e8a64b56601ef3d11da71"
    sha256 cellar: :any,                 big_sur:        "787efa74f2fb29cac77ec4841970ece1e7213c07823b3643a814434122c7164e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10de2e7fbe58d6a1fe8fee9e6e67e424a8ef5fb171619c37dc7bb3598703161f"
  end

  depends_on "cffi"
  depends_on "libgit2@1.5"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    system python3, *Language::Python.setup_install_args(prefix, python3)
  end

  test do
    assert_empty resources, "This formula should not have any resources!"
    (testpath/"hello.txt").write "Hello, pygit2."
    system python3, "-c", <<~PYTHON
      import pygit2
      repo = pygit2.init_repository('#{testpath}', False) # git init

      index = repo.index
      index.add('hello.txt')
      index.write() # git add

      ref = 'HEAD'
      author = pygit2.Signature('BrewTestBot', 'testbot@brew.sh')
      message = 'Initial commit'
      tree = index.write_tree()
      repo.create_commit(ref, author, author, message, tree, []) # git commit
    PYTHON

    system "git", "status"
    assert_match "hello.txt", shell_output("git ls-tree --name-only HEAD")
  end
end
