class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/db/26/cd0d68706e9511ca07b10d53f42e70d4c57b3504f4a0fd675e4617ad7a60/pygit2-1.12.2.tar.gz"
  sha256 "56e85d0e66de957d599d1efb2409d39afeefd8f01009bfda0796b42a4b678358"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6e93a3ac65163d5f26f54ce25f69756b1964b2bbac8092162e226d3519bc03db"
    sha256 cellar: :any,                 arm64_monterey: "d8adb47b0086f2bf667da0af8c2d5caeead297c26c0355fdb70bfd98aaaec7fb"
    sha256 cellar: :any,                 arm64_big_sur:  "701a508ac8c5ce63f7d67759ab02b2df3f94c171e764419f165fffb4d071ba89"
    sha256 cellar: :any,                 ventura:        "d6ed893ebee2daa24489c6ebafa165c13a6823791f9e30df80c6c7fe82784072"
    sha256 cellar: :any,                 monterey:       "fac238723a87e9ef1535cd086fce595fe89c1927c2df1be44c7ff009e268f48f"
    sha256 cellar: :any,                 big_sur:        "ba4f02bd2985e905843137cb1d36da922e1a65c339ab9c678b65137b73f27f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe2b9fe2c45e64d373d67bd80a8f5a3e0e09d3764f992a67e7509f3d39792f10"
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
