class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/c1/4a/72a5f3572912d93d8096f8447a20fe3aff5b5dc65aca08a2083eae54d148/pygit2-1.18.0.tar.gz"
  sha256 "fbd01d04a4d2ce289aaa02cf858043679bf0dd1f9855c6b88ed95382c1f5011a"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "15e1773e05f8fc685fdcb8f312a2229ef95e13a07439ef05b3e0739258cd72cc"
    sha256 cellar: :any,                 arm64_sonoma:  "6a0e000b2cdcf75710eeedc2b11e8394904e226ba8f85397f61b0527d14e14f7"
    sha256 cellar: :any,                 arm64_ventura: "e4f58494b0888b4895119214f28bf0b0318d6caa813d96b25f6b66b19144163c"
    sha256 cellar: :any,                 sonoma:        "f3a5c74edf5535663fe1c6f07b64c4c0c4bf70720bb6ebd59a5115b800dda225"
    sha256 cellar: :any,                 ventura:       "c9f6b051139c27561442e5f7dd0549b07f617f92bf3ac875235352a8853095e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e3f7ec5aa21746f1858b947eebcc6ffedac2ac50c0d3fa4f31ae2a8b81a90e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2848a70fbce205a1cc0d0f150f26d9abc43571104f0a47d6d5d4a6091db7c03d"
  end

  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "cffi"
  depends_on "libgit2"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    assert_empty resources, "This formula should not have any resources!"

    pythons.each do |python3|
      pyversion = Language::Python.major_minor_version(python3).to_s

      (testpath/pyversion/"hello.txt").write "Hello, pygit2."
      mkdir pyversion do
        system python3, "-c", <<~PYTHON
          import pygit2
          repo = pygit2.init_repository('#{testpath/pyversion}', False) # git init

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
  end
end
