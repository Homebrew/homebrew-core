class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/48/6b/1c20d9adf9906e699bdb505322b27c71e12d7250d8454ae88dcecdf10296/pygit2-1.12.1.tar.gz"
  sha256 "8218922abedc88a65d5092308d533ca4c4ed634aec86a3493d3bdf1a25aeeff3"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "15e55049b89b3b7212d98d8f097d4e9c47a22fd9b89b25de852c9d263078bb57"
    sha256 cellar: :any,                 arm64_monterey: "62b29d6296c928aa758cb7c470d85923b815078d8bbfab443e7fa756fcd89a4d"
    sha256 cellar: :any,                 arm64_big_sur:  "b6952ca08e0838388028f10f26193bbeabf063ee30ae7a2b2e991f3a9434ae96"
    sha256 cellar: :any,                 ventura:        "930abb3ed0e772042caebf23be133d4a9464aea4f0e4c58c8becf141a1bfc7e8"
    sha256 cellar: :any,                 monterey:       "6ef228c24296c7d08926ce05cdadb2664f5c71dacc81df498d59fb54b4dccfe8"
    sha256 cellar: :any,                 big_sur:        "65c20ba4d1e18a85fcd087f0f3feaad5c0599e6a25fc74bd7b4e62fc4d7a25a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dfade523e3bf42761a6e26e5fb94b3bf2acb3699d70ee9dca7f1cf9489eab36"
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
