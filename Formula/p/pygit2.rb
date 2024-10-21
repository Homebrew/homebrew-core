class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/a4/85/c848cdf44214bf541c4a725a0a6e271f8db9f18cfccef702d53f83f1e19a/pygit2-1.16.0.tar.gz"
  sha256 "7b29a6796baa15fc89d443ac8d51775411d9b1e5b06dc40d458c56c8576b48a2"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2bdefe79cffeb8fef4504b49bb6e10da8f8f6a1ad4f06de0cd14bcde65e0da06"
    sha256 cellar: :any,                 arm64_sonoma:  "fd5ecbab353e4990cb4d11972191dbc0a8c29c0768c152a5aab39f29e4de0937"
    sha256 cellar: :any,                 arm64_ventura: "e6c0cf19f7093ae9addfed9f596bb221c6a7695a6ed8ce971e270e61f64d1a6d"
    sha256 cellar: :any,                 sonoma:        "0f200d9cfba5fac088a8036163afb1bad97a0c3e51b3595603ce28aca42a29d8"
    sha256 cellar: :any,                 ventura:       "571795c815fe4588579e6912a0fea4b7e0054cea9f9f9ed89da2f9e56dd24217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a94b5d02dc781e9bc927c850b599b34b6915b02f03341c1c744e434a1ae1a25"
  end

  depends_on "python@3.11" => [:build, :test]
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
      pyversion = Language::Python.major_minor_version(python3)

      (testpath/"#{pyversion}/hello.txt").write "Hello, pygit2."
      mkdir pyversion do
        system python3, "-c", <<~PYTHON
          import pygit2
          repo = pygit2.init_repository('#{testpath}/#{pyversion}', False) # git init

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
