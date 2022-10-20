class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/Alexis-benoist/eralchemy"
  url "https://files.pythonhosted.org/packages/87/40/07b58c29406ad9cc8747e567e3e37dd74c0a8756130ad8fd3a4d71c796e3/ERAlchemy-1.2.10.tar.gz"
  sha256 "be992624878278195c3240b90523acb35d97453f1a350c44b4311d4333940f0d"
  license "Apache-2.0"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b6d4cb1be8dbc27afb9b6c6db6de4e74b53df3616be44eb297d269baa3e0aa1a"
    sha256 cellar: :any,                 arm64_big_sur:  "b00010ac117e4132bc096868a9f19756b61622a925e3651900518268e88957a7"
    sha256 cellar: :any,                 monterey:       "123aeeadfe90378d56c1682ae5c3fb5011b9e0fe4cd4ced344da8c78af9b81a6"
    sha256 cellar: :any,                 big_sur:        "68f658eb8bb7a7c2a85a328445b10aa44e1b00e8090129089f143de22f0cea57"
    sha256 cellar: :any,                 catalina:       "e666bece0ef21146cba70ca4a723bcd30964adb1f4ef1a45a5b68e5a630e4dca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abd00f4df6d6b75f3adc4ea2e19859a660ea59ad5e9bb7b048a89fea5825ba78"
  end

  depends_on "pkg-config" => :build
  depends_on "graphviz"
  depends_on "libpq"
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  resource "psycopg2" do
    url "https://files.pythonhosted.org/packages/fd/ae/98cb7a0cbb1d748ee547b058b14604bd0e9bf285a8e0cc5d148f8a8a952e/psycopg2-2.8.6.tar.gz"
    sha256 "fb23f6c71107c37fd667cb4ea363ddeb936b348bbd6449278eb92c189699f543"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/1e/19/acf3b8dbd378a2b38c6d9aaa6fa9fcd9f7b4aea5fcd3460014999ff92b3c/pygraphviz-1.6.zip"
    sha256 "411ae84a5bc313e3e1523a1cace59159f512336318a510573b47f824edef8860"
  end

  resource "SQLAlchemy" do
    url "https://files.pythonhosted.org/packages/69/ef/6d18860e18db68b8f25e0d268635f2f8cefa7a1cbf6d9d9f90214555a364/SQLAlchemy-1.3.20.tar.gz"
    sha256 "d2f25c7f410338d31666d7ddedfa67570900e248b940d186b48461bd4e5569a1"
  end

  resource "er_example" do
    url "https://raw.githubusercontent.com/Alexis-benoist/eralchemy/v1.1.0/example/newsmeme.er"
    sha256 "5c475bacd91a63490e1cbbd1741dc70a3435e98161b5b9458d195ee97f40a3fa"
  end

  def install
    venv = virtualenv_create(libexec, "python3.10")
    venv.pip_install resources.reject { |r| r.name == "er_example" }
    venv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/eralchemy", "-v"
    resource("er_example").stage do
      system "#{bin}/eralchemy", "-i", "newsmeme.er", "-o", "test_eralchemy.pdf"
      assert_predicate Pathname.pwd/"test_eralchemy.pdf", :exist?
    end
  end
end
