class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/eralchemy/eralchemy"
  url "https://files.pythonhosted.org/packages/1b/cc/d41f21c662b244efedabac91705834c59dcf43b09e74dbc2b5ff32ea8b1c/eralchemy-1.7.0.tar.gz"
  sha256 "926376fdab2e1ca8eec05698c457d17718ed1458fa574b67e815c43ae52b377a"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "4394105ed86de197b8dc0eeb9089fa7f2bd60870263963e8c9671e4ba72c51af"
    sha256 cellar: :any, arm64_tahoe:       "73c2f4d4258c3e8d0f6099eaa6afaeeca4c21e8b542d067e63df8b21376cf832"
    sha256 cellar: :any, arm64_sequoia:     "333dbe99f334ed3ed6b24a15404229373391655538a85c8b40df56c4bb0f8317"
    sha256 cellar: :any, arm64_linux:       "18f99852c7b6fcde3d12990676947365f4ef15d120fb04a9574af1d217b9f158"
    sha256 cellar: :any, x86_64_linux:      "7b7fe10ce569dbd49c19b1ed8bf3def54ed793668c63aca457fe929a157a07a5"
  end

  depends_on "pkgconf" => :build
  depends_on "graphviz"
  depends_on "python@3.15"

  pypi_packages package_name: "eralchemy[pygraphviz]"

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/01/f7/a82e7f47573168960ce7e2a6c937a084a14d58599fe2a48ea3cde8ca555b/pygraphviz-2.0.3.tar.gz"
    sha256 "e46818608638959ceabec66a36d2efc1d60b790a845f29705e403feecc7ee0c0"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/1f/44/311bac6b6ef81e4dfd0287d04900108b1f5c00c9761dd3c0a2b7b9d0f86b/sqlalchemy-2.1.4.tar.gz"
    sha256 "7bd7ad604487daa7eab8716471c29a7185f17b5287ce73bb7bc79fea050d8cfd"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "er_example", :test do
    url "https://raw.githubusercontent.com/Alexis-benoist/eralchemy/refs/tags/v1.1.0/example/newsmeme.er"
    sha256 "5c475bacd91a63490e1cbbd1741dc70a3435e98161b5b9458d195ee97f40a3fa"
  end

  def install
    # Work around pygraphviz source-build discovery and runtime paths for nonstandard prefixes.
    # https://github.com/pygraphviz/pygraphviz/issues/630
    if OS.linux?
      graphviz_prefix = formula_opt_prefix("graphviz")
      ENV["GRAPHVIZ_PREFIX"] = graphviz_prefix
      ENV.append "LDFLAGS", "-Wl,-rpath,#{graphviz_prefix}/lib/graphviz"
    end
    virtualenv_install_with_resources
  end

  test do
    system bin/"eralchemy", "-v"
    resource("er_example").stage do
      system bin/"eralchemy", "-i", "newsmeme.er", "-o", "test_eralchemy.pdf"
      assert_path_exists Pathname.pwd/"test_eralchemy.pdf"
    end
  end
end
