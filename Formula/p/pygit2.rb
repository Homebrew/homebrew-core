class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://www.pygit2.org/"
  url "https://files.pythonhosted.org/packages/a6/44/415aa93422b4bfc21a6448acb7e16280d5f33a9a3fae38a384e37b046ae4/pygit2-1.19.3.tar.gz"
  sha256 "a543e6d4ebb43825564935758dc234e770016fed673b84370d46ae9580558831"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  compatibility_version 1
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "943128ffecf388b567b33a6af0bb156cf8e7331c864baff75e7293c4f989aaa3"
    sha256 cellar: :any, arm64_sequoia: "1acaec4c8d2db3a3315059d8c52149151ea7b621116e6f75474eedf35e6d387f"
    sha256 cellar: :any, arm64_sonoma:  "ebfb9fbc818fc003bdd0e1ae07ade23add6d89e2c3dc608b3c9e851d836f9935"
    sha256 cellar: :any, sonoma:        "095cb288d14b0c91c8112df910614cb1e2a3e2ab805daf89210af355ffba785d"
    sha256 cellar: :any, arm64_linux:   "d8d4bafa9c7119b8b35a8ccabc4b4f410e130be4c7355717c33c7f713db02f5e"
    sha256 cellar: :any, x86_64_linux:  "708e65e2735fcb44c3d62e299cf528620a74844eb96dd4b8ecb5721562e19cbe"
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
