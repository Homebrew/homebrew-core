class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/b7/ea/17aa8ca38750f1ba69511ceeb41d29961f90eb2e0a242b668c70311efd4e/pygit2-1.17.0.tar.gz"
  sha256 "fa2bc050b2c2d3e73b54d6d541c792178561a344f07e409f532d5bb97ac7b894"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "35ce700b913b3b7dfe0c5c890f116d2608b0d95217a75df2cad529dc952054da"
    sha256 cellar: :any,                 arm64_sonoma:  "1baf23308186b46433b96694756e1ea8928db981b4280caa1a6087545f0ef2f2"
    sha256 cellar: :any,                 arm64_ventura: "94d38f06b415396e2d573971f7f735d6442c1090c6b1b06579fc560e2efd58a1"
    sha256 cellar: :any,                 sonoma:        "46f23033146c07667df84d155d1f172a678ab655d2693ab60c4d90cbbd455684"
    sha256 cellar: :any,                 ventura:       "60fcff9d3db9cdf27ba41e6888e8b38629e5ab945f0a695496bcfbc60582fb1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4b26f1a576237e542c38f4bddad2980da31ad4aa1debfdfe26636a1f2946d3f"
  end

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
