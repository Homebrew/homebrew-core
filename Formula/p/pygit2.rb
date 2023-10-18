class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/73/05/cb50b5eb86fd67e36a6711fd41ef19bd614e95c5f37b28550407b100871a/pygit2-1.13.1.tar.gz"
  sha256 "d8e6d540aad9ded1cf2c6bda31ba48b1e20c18525807dbd837317bef4dccb994"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "3570a63deaff1a4ee535473c3ea2941dcf075bdec5af77c015d18e7e3a448257"
    sha256 cellar: :any,                 arm64_ventura:  "0280f20e14d705c4ce4c31e55c0684b6930bf39ee5175695bb31c109e06b5646"
    sha256 cellar: :any,                 arm64_monterey: "7495beb2a0b430d4446657cb44a5e7b474401e9535b3641d5efc8b4a4ed6b31b"
    sha256 cellar: :any,                 sonoma:         "45bda0b079cb0ee004a803e3e913d507b0996970c13eb7f345d6356ecad10438"
    sha256 cellar: :any,                 ventura:        "5c7041a1110ee51415f316cc4cee88fc880c289a0feeb5d23517873573a3f5f0"
    sha256 cellar: :any,                 monterey:       "88ed73b0413d5e32b3e384d244e507d0a5d7f34879897bfec86ff7fba3c4e235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82cf7190b95560e59a41683a52183963010be4c70cb2b63f037f32b5a0e13176"
  end

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
