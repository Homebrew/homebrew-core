class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/f0/5e/6e05213a9163bad15489beda5f958500881d45889b0df01d7b8964f031bf/pygit2-1.14.1.tar.gz"
  sha256 "ec5958571b82a6351785ca645e5394c31ae45eec5384b2fa9c4e05dde3597ad6"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "54563311867d16e731a50966bacea00fadf9eb0bafc9b49826d3e4f07b6c6300"
    sha256 cellar: :any,                 arm64_ventura:  "c507e5bd1a2aa191f3b313191de95057fc2298965fdfa255f368c89e45077cd2"
    sha256 cellar: :any,                 arm64_monterey: "0875766eac458047e8022d5ed28fb7faf7f0e3b739571d0f191959ba9b6d9009"
    sha256 cellar: :any,                 sonoma:         "a37b6b540ecf77b1fa6d9a406bcd7e34a6f723a83fb61df1e6cdd9aabb7e5be5"
    sha256 cellar: :any,                 ventura:        "0d02be9979b8a3c75c641a714af62c26e78b2726f84557e821bbd7ce459c77fd"
    sha256 cellar: :any,                 monterey:       "cba983c98e9099a1c677de6ac63c861c3b7c8421a57c448954dff0e92b6b39dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe2b16dccff436557353ca888557f6a652e7eff3f70d0e430a54ee757fa06b1b"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "cffi"
  depends_on "libgit2"

  def pythons
    deps.select { |dep| dep.name.start_with?("python@") }
        .map(&:to_formula)
        .sort_by(&:version)
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    assert_empty resources, "This formula should not have any resources!"

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      pyversion = Language::Python.major_minor_version(python_exe)

      (testpath/"#{pyversion}/hello.txt").write "Hello, pygit2."
      mkdir pyversion do
        system python_exe, "-c", <<~PYTHON
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
