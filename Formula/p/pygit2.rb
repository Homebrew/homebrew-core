class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/6c/4b/da6f1a1a48a4095e3c12c5fa1f2784f4423db3e16159e08740cc5c6ee639/pygit2-1.19.0.tar.gz"
  sha256 "ca5db6f395a74166a019d777895f96bcb211ee60ce0be4132b139603e0066d83"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c423238a2a9248d8e87bd250c401b2f88f50f476fcefc69f660eb868303b71de"
    sha256 cellar: :any,                 arm64_sequoia: "a5ff092a5dd0c38f6786ecc4b444640678c7d9e1a4734a7c3cddf3a69cf9ea85"
    sha256 cellar: :any,                 arm64_sonoma:  "bdb60a77d388a037941975a278119509510163c692094b7c72d57f5cc959a5ad"
    sha256 cellar: :any,                 sonoma:        "f08387023d4714e1308680923feafda014e4b539e164a9dc278f461170f44520"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97833a1c9ad4c54da82fcc7af8265979575a675a00f70e8163ae8b5e492e0cef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "119c10991289e7b902f9540d8624b2d04d5d79b97c130386848016461effc2fb"
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
