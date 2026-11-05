class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://www.pygit2.org/"
  url "https://files.pythonhosted.org/packages/6a/13/f61226355815c93a2aad4f70b0d5a4df54d043a963bc51e81146623424c2/pygit2-1.21.0.tar.gz"
  sha256 "1e987fbef899d1bf12aecc10b33acc917d60266ca114428dfc260df4451a555f"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  compatibility_version 1
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c31b03e9d2c538dbe9279bbd27d21ed5f024795ccb4e5340f5182b83aee03403"
    sha256 cellar: :any, arm64_tahoe:       "a292fa3115fd38d6fc7cba43bba9aa0064b10416edfc0515ef72ad5d61c189e9"
    sha256 cellar: :any, arm64_sequoia:     "e8ce4ca7836816dcb1e08615c577101253b2785b4bf715242bbd87c2c3ac6238"
    sha256 cellar: :any, arm64_linux:       "867711008f6b4c1b0880906f04665488f4c075af928e2ec87c1ef863fd76c7b8"
    sha256 cellar: :any, x86_64_linux:      "0c6ebe0ec00046a4aa73f6dcf83434596a63ba278e833cdeb1758da0a8fba807"
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
