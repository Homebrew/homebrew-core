class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://www.pygit2.org/"
  url "https://files.pythonhosted.org/packages/9c/11/592cc7854795830a7257ab6025a1fc803b58b0e7bf7d31f619bc7288ed4d/pygit2-1.20.1.tar.gz"
  sha256 "36dff84d237f2b8f18b0b146d6e7c3f99a7bce2da98cc4103a14387f53319f95"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  compatibility_version 1
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e2abda1fe37ef063c31a915d17cbdd21306ad1290f5ff7baa8462be740acc093"
    sha256 cellar: :any, arm64_tahoe:       "b75937a6e4604325f7197e3a3b3fab48c2c67da3b38e6a4acd5eee4f134b0ba4"
    sha256 cellar: :any, arm64_sequoia:     "7a2a7fa73b46aa24fe72d1182b208ffcd6755d9c8b2ac264dbb9260d0f3df472"
    sha256 cellar: :any, arm64_linux:       "78e34cc4ada6ed12cda9fa6161f5f9cb6c4c56a4b2e60ff88807eb57afbf3af5"
    sha256 cellar: :any, x86_64_linux:      "dedef89ae1f9d119a1d0fce35f78205ecfe4efcb3430ea4e0efcbdc66b46d831"
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
