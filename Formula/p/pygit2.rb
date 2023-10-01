class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/73/05/cb50b5eb86fd67e36a6711fd41ef19bd614e95c5f37b28550407b100871a/pygit2-1.13.1.tar.gz"
  sha256 "d8e6d540aad9ded1cf2c6bda31ba48b1e20c18525807dbd837317bef4dccb994"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2fba8fac58cf102f1057415185ea46c25df7e92f509a597e7fa69af50e1ddc98"
    sha256 cellar: :any,                 arm64_ventura:  "20123682a149d5f8c43a540d2f40dbf6e5d7a417b45a1fff9b448d78d8d88b82"
    sha256 cellar: :any,                 arm64_monterey: "0aed61b18dd7aa0b5d1b163215f4e375e747a71e1407f9bb28685e9e94490424"
    sha256 cellar: :any,                 arm64_big_sur:  "24a375683dd328703f62b4e1cdd04d68f789104ee253b34d57a7d7fd7fa3b6c3"
    sha256 cellar: :any,                 sonoma:         "2b59a58f718a19899649ce7057bf112eb1441e82bc23ea1273059e304755a0ab"
    sha256 cellar: :any,                 ventura:        "34ab561bd3e21beccedc9d95e64aa275080801d7f44d4b0803b1790a4e670b0e"
    sha256 cellar: :any,                 monterey:       "0d2eb22838b068163bc7b6b1cf604ee2b3e787c1520087252b730be11da57ce1"
    sha256 cellar: :any,                 big_sur:        "c2da9faec8229d7a9a4ce8e5348d3367fb4abf1527bf4f1e4f347ab29764e73c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0aa0d8f151dd83a88d4eb24127d347d9746725657a94da91a6a40a044f6711f"
  end

  depends_on "cffi"
  depends_on "libgit2"
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
