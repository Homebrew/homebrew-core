class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  # TODO: check if we can use unversioned `libgit2` at version bump.
  url "https://files.pythonhosted.org/packages/db/26/cd0d68706e9511ca07b10d53f42e70d4c57b3504f4a0fd675e4617ad7a60/pygit2-1.12.2.tar.gz"
  sha256 "56e85d0e66de957d599d1efb2409d39afeefd8f01009bfda0796b42a4b678358"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  revision 1
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "22f0fa908d1b0c7fdd641870f91d43d92644d4faabba5290bc39ae31ae952fb7"
    sha256 cellar: :any,                 arm64_monterey: "de6a514750633ac304c0d49fc36301214dca7d0fd1fc092a8aaaec575f958409"
    sha256 cellar: :any,                 arm64_big_sur:  "4682bfadb61a9b2607ca9db9c6d361142b7c765d91f5245e6c322b12abe89bd3"
    sha256 cellar: :any,                 ventura:        "a79aa69152665012c3ac58143adfb9c03362c38106750a7e78c76d02ef41674b"
    sha256 cellar: :any,                 monterey:       "05ff09ea91d8e9bf286e276cb2e0ca9c57fc69289db4b98dd16c3fbae4d067af"
    sha256 cellar: :any,                 big_sur:        "951cff1fbdc544daeb39fe4ca20a76b6ecff665248bad7e170552e0a6461451c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a124bcb5a55ede4a35ab79e4e22fd3f2e48f3640cbf446beba101f214c650fbd"
  end

  depends_on "cffi"
  # If commit https://github.com/libgit2/pygit2/commit/1473e8eb6eb59dc7521dcd5f8a4c9390e9b53223
  # is included in the release, then `libgit2` 1.7.x can be used.
  depends_on "libgit2@1.6"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
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
