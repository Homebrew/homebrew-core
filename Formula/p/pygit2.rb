class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/3a/a4/10ce00feef5c43eddacab19ae6610c4d4ef3ab77e544e9ee938772cd1c17/pygit2-1.19.2.tar.gz"
  sha256 "cbeb3dbca9ca6ee3d5ea5d02f5e844c2d6084a2d5d6621e3e06aa2b11c645bfd"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  compatibility_version 1
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bfdc0abcc0ccc4e69789f3dc14e728db7b3184e11fbebb305d9a05ad1bc7e4d6"
    sha256 cellar: :any,                 arm64_sequoia: "2f8e22c0c4e9205e96ee57c6ce21006a0ea79cbede397d921a17aab5a9abbe55"
    sha256 cellar: :any,                 arm64_sonoma:  "2c700aa068287e7bd398ee594beecefdfd98057cb43aa510ca29cb0669bb021b"
    sha256 cellar: :any,                 sonoma:        "0b94b6108da12f11f0ac5c4acc8ccf7734a3adf879996d437ca1d1951cfaf9c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f03c9fc5a888a0054368674d740ee1b5d087c1ade0f4cd8c6408e26a237ccea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "188d7b172fe47d0cef2bd4ce113d14b8269d9482c8195fba68b8a12903e0fbbc"
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
