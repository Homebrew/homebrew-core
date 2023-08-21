class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/db/26/cd0d68706e9511ca07b10d53f42e70d4c57b3504f4a0fd675e4617ad7a60/pygit2-1.12.2.tar.gz"
  sha256 "56e85d0e66de957d599d1efb2409d39afeefd8f01009bfda0796b42a4b678358"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "50d0698bb194f8e19ee8b26eca8c3a1362cf468dc0286f8f1e7b5fd08338109b"
    sha256 cellar: :any,                 arm64_monterey: "ec798b4c494eeaab104671f73e907eeaa14301dd106db94696b3d8851cde6d5e"
    sha256 cellar: :any,                 arm64_big_sur:  "7e4da4c4d21d93344b34d6db2a37cfeb2e1fefe8b2944580d9454797602e775e"
    sha256 cellar: :any,                 ventura:        "733df708e7b6c8016704ac3f8ec8392bfaaf36bf0c5005c49045f029d39fae25"
    sha256 cellar: :any,                 monterey:       "c47fc76186c79f21f38e89d6da8bd31e86138ad687b17bf01306780ce109dcd0"
    sha256 cellar: :any,                 big_sur:        "743091d3ac0384f3f0aef487da81ea95404a5aaf5f866442e4a101c5c0ef3b02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd4e7397d8d8cbe316a2548302deb636c12071bb777c32dd13fadc8a3aa24e99"
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
