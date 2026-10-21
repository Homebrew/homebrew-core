class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://www.pygit2.org/"
  url "https://files.pythonhosted.org/packages/9c/11/592cc7854795830a7257ab6025a1fc803b58b0e7bf7d31f619bc7288ed4d/pygit2-1.20.1.tar.gz"
  sha256 "36dff84d237f2b8f18b0b146d6e7c3f99a7bce2da98cc4103a14387f53319f95"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  revision 1
  compatibility_version 1
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6b9d27606c9f39b72a196ec82f00a42c80bb62417592f733945d84f5bee9fefd"
    sha256 cellar: :any, arm64_tahoe:       "43d71afdcb58948ec726f2114403b7fbfe0ec291c8e76d0e0bb1973194141ef9"
    sha256 cellar: :any, arm64_sequoia:     "eecc90639d6e5078d4331e44398b98c03909057bda77814dd85972895cca654c"
    sha256 cellar: :any, arm64_linux:       "11f2babe0f9e921f3876567e26177b24f7ca617df3c7da258fdd01d884e544a2"
    sha256 cellar: :any, x86_64_linux:      "2ba250b5ee0775a76898d32b402010485f7b27385bdc2d0c675c70c929eaaabb"
  end

  depends_on "python@3.14" => [:build, :test]
  depends_on "python@3.15" => [:build, :test]
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
