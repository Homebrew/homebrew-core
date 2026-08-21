class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://www.pygit2.org/"
  url "https://files.pythonhosted.org/packages/f1/54/9273c78efd3d570091af585bdeb68a46089e80602dafe11989cca40c6d0f/pygit2-1.20.0.tar.gz"
  sha256 "7253735629c22fff412a72c48c204b19c206fda9fcb01e51113d9689194cb1cf"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  compatibility_version 1
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "014b443ecfadb43fea1f8be1e2d192d90ff6ac22f254c4fe70f116d48ba11370"
    sha256 cellar: :any, arm64_sequoia: "5aae17d0cb36ba04cd2fe7ca4284c8ef9555fcc529c0de091fb2c9b9d39101d7"
    sha256 cellar: :any, arm64_sonoma:  "cbc2582c691dc88e8f25fb42325f0d9eb86ee3166f0dcdfc96eba83941793d41"
    sha256 cellar: :any, sonoma:        "933d7b2dc5bb69dfb6570bdb5d5eafe18a668eeb646bd27c0eb380ebde0df69a"
    sha256 cellar: :any, arm64_linux:   "285e4f9e42ad8a76b6d2c88901c4d8b6aaa6b6256ef0f0bfbd69d9c7537f3daf"
    sha256 cellar: :any, x86_64_linux:  "f01f8e53269c2e436a399e7b9e13d60272ebc5bdd0b86b8a74750992a533a9e5"
  end

  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "cffi"
  depends_on "libgit2"

  pypi_packages exclude_packages: %w[cffi pycparser]

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
