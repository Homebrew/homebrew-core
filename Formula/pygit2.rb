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
    sha256 cellar: :any,                 arm64_ventura:  "9453ad61e5e525c57a6a667ee2f6dafe787e24491af80817c95f0bc5a656cc10"
    sha256 cellar: :any,                 arm64_monterey: "1608908e2e6d47a93a4f9dbc535a860daeba98ae324156ee8de2758a12d7ad96"
    sha256 cellar: :any,                 arm64_big_sur:  "510f9e7195127118e6820478dbc77ebcce480bad25caf1279783fc955777a6f9"
    sha256 cellar: :any,                 ventura:        "b56a942dc7c7fafe53c17b8f64e19b51a24cafb766ea999bfec30016730ddd8b"
    sha256 cellar: :any,                 monterey:       "c6848c85a2b795f7f9abaf4ff169df4181cc6bddf2cf9e2d603a7c93b3a95747"
    sha256 cellar: :any,                 big_sur:        "49cba7208c3ddd74368dd071e6a0197e8809ab9e4df3b9717eb3eabf40d58fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15c06e62ed0d37a97b9ddc54e0395a2820048ea65cd10ba00b296c24148aecb6"
  end

  depends_on "cffi"
  depends_on "libgit2@1.5"
  depends_on "python@3.11"

  # TODO: Remove ASAP after merge.
  conflicts_with "libgit2", because: "inadvertently links with unversioned `libgit2` while building"

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
