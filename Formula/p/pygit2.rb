class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/2e/ea/762d00f6f518423cd889e39b12028844cc95f91a6413cf7136e184864821/pygit2-1.18.2.tar.gz"
  sha256 "eca87e0662c965715b7f13491d5e858df2c0908341dee9bde2bc03268e460f55"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cbcca78f2fae8e568169e05b9009bb05aa4bcea6841df44902fc692a07df5c19"
    sha256 cellar: :any,                 arm64_sequoia: "0c41ea826ccb943e0da45891ee966980911266e8bf139e7a8114fe82b12ea441"
    sha256 cellar: :any,                 arm64_sonoma:  "bbc103feb711cab9eb037bda6198c1abe2fe53d5b73d70ae5651a302e35aa766"
    sha256 cellar: :any,                 arm64_ventura: "d045db881065a632728c36c0741cd275c0c523ec58f962914ede6d0128bfd19f"
    sha256 cellar: :any,                 sonoma:        "3afa4920d09d880f937ac6093e2117218e65402ea3eb9c46ce50c6f6fb771cc3"
    sha256 cellar: :any,                 ventura:       "14d934763e0db603419e7bdec78de1fd073daee88ec5d36f68b41d8dcab33f4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67a73260c2648a77dc935c177b974691688515d673a563e2195408b86f4f15bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afe9a12558e04e48e9c7048bea7c2077a0fe9de3ffb2a5de338546210a985016"
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
