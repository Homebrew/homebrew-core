class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/7f/00/075f21ae474fcef679ba1f71b9ecd534493792b508b1919021fb2be67eba/pygit2-1.12.0.tar.gz"
  sha256 "e9440d08665e35278989939590a53f37a938eada4f9446844930aa2ee30d73be"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b2b96dcbe80938a2382dadfb4ed9cd1649c35528726bf39c7b367dbe5112e568"
    sha256 cellar: :any,                 arm64_monterey: "05c60afd25b816156104f00894705815cd6426537cb4f086dbfae82933c36d7f"
    sha256 cellar: :any,                 arm64_big_sur:  "fd617c0c992d48c8d76da8569cd6ba7cc6dc0dc057f79aed317499761893da98"
    sha256 cellar: :any,                 ventura:        "32820e2afdc3ff8d1d9977aedb2d5db01ea5d4ead43466815bde73013c238db3"
    sha256 cellar: :any,                 monterey:       "885096ae148dd74f628ef65abf3d0ad9253dd78a5fc46d808fb813ee0f86b8b8"
    sha256 cellar: :any,                 big_sur:        "606f25eabf149ad5929e1e3362d0e0eff9934a119323b2938a43288fd43e29e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfacdf57f9dca19a6defcdbe9367ef6cb160c98a75bfe852e3be1c3a59b0d665"
  end

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
