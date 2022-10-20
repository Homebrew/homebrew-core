class Codemod < Formula
  include Language::Python::Virtualenv

  desc "Large-scale codebase refactors assistant tool"
  homepage "https://github.com/facebook/codemod"
  url "https://files.pythonhosted.org/packages/9b/e3/cb31bfcf14f976060ea7b7f34135ebc796cde65eba923f6a0c4b71f15cc2/codemod-1.0.0.tar.gz"
  sha256 "06e8c75f2b45210dd8270e30a6a88ae464b39abd6d0cab58a3d7bfd1c094e588"
  license "Apache-2.0"
  revision 5
  version_scheme 1
  head "https://github.com/facebook/codemod.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcf3de80ebdad83809c2f691f5fdcf8f07a395c55cee6fa9cc332a0847eead33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcf3de80ebdad83809c2f691f5fdcf8f07a395c55cee6fa9cc332a0847eead33"
    sha256 cellar: :any_skip_relocation, monterey:       "b23035b282c74a9394e85d9a0223b1ddb677151c134da0468ad0713ab3658e7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b23035b282c74a9394e85d9a0223b1ddb677151c134da0468ad0713ab3658e7e"
    sha256 cellar: :any_skip_relocation, catalina:       "b23035b282c74a9394e85d9a0223b1ddb677151c134da0468ad0713ab3658e7e"
    sha256 cellar: :any_skip_relocation, mojave:         "b23035b282c74a9394e85d9a0223b1ddb677151c134da0468ad0713ab3658e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf1dd93571d01049de387a06571f81968d273c3028f96888e76121c87b8d6dd7"
  end

  disable! date: "2022-07-31", because: :repo_archived

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    # work around some codemod terminal bugs
    ENV["TERM"] = "xterm"
    ENV["LINES"] = "25"
    ENV["COLUMNS"] = "80"
    (testpath/"file1").write <<~EOS
      foo
      bar
      potato
      baz
    EOS
    (testpath/"file2").write <<~EOS
      eeny potato meeny miny moe
    EOS
    system bin/"codemod", "--include-extensionless", "--accept-all", "potato", "pineapple"
    assert_equal %w[foo bar pineapple baz], File.read("file1").lines.map(&:strip)
    assert_equal ["eeny pineapple meeny miny moe"], File.read("file2").lines.map(&:strip)
  end
end
