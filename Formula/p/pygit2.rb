class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/17/49/cf8350817de19f4cafe4ae47881e38f56d9bbebaa9e5ef31a5458af4bcf8/pygit2-1.19.1.tar.gz"
  sha256 "3165f784aae56a309a27d8eeae7923d53da2e8f6094308c7f5b428deec925cf9"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "15f26a039eaeb8cf8650eaec7fb59014823ed90e02c161b9b982683382499fe9"
    sha256 cellar: :any,                 arm64_sequoia: "fcf1dcb11ab25e0fae1c66ecfb8641c61b77e617156ce2773cae310bf40d8079"
    sha256 cellar: :any,                 arm64_sonoma:  "a2742cf033a1434640c0b70cdf44447d7ccce26c3e19aa34eb2777c6c3936ecf"
    sha256 cellar: :any,                 sonoma:        "095d41bf399bc7b46c6f531c6ffec33913b2dd70a42c08ac44d37b5b21df3581"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c02462e83c3919b1125f1e442b252ae3ab69f993dcd7ee82e8d6ca5347326b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76d50bbc5185231ce8bcb987b07afaa758c5f8af3dbc888315f3c4082fa325cb"
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
