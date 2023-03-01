class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/43/9a/f4375f39d2de971750a7c16bd7ab9cc53368f395edaac59b32e9b3f62ce9/pygit2-1.11.1.tar.gz"
  sha256 "793f583fd33620f0ac38376db0f57768ef2922b89b459e75b1ac440377eb64ec"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  depends_on "cffi"
  depends_on "libgit2"
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
