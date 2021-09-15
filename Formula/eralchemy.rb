class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/Alexis-benoist/eralchemy"
  url "https://files.pythonhosted.org/packages/87/40/07b58c29406ad9cc8747e567e3e37dd74c0a8756130ad8fd3a4d71c796e3/ERAlchemy-1.2.10.tar.gz"
  sha256 "be992624878278195c3240b90523acb35d97453f1a350c44b4311d4333940f0d"
  license "Apache-2.0"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d925eb8686a32d2bbf7b9bab62f65f6b761952dcb32923ef7b6428f5325c11a1"
    sha256 cellar: :any,                 big_sur:       "2a5ce41209235c75eeb092f0b6c17c6c46c03f2faada2b2a337fcda7f28a4288"
    sha256 cellar: :any,                 catalina:      "e844701e7824dc9497969cc6592302bf56ac060d5aa18105e1ee2887411a5f12"
    sha256 cellar: :any,                 mojave:        "cfb423a7299d1d307e58aa756675f26ea65ad405e6e2fb707727de49aa36eb64"
    sha256 cellar: :any,                 high_sierra:   "cb2442baa298aa27c860ad7d80116131f286ea283625dbd809d4b518ba81707a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33457b7cd8520565ade9b63b2ea9597b0e695652ded2414d0da61425a2eb8744"
  end

  depends_on "pkg-config" => :build
  depends_on "graphviz"
  depends_on "libpq"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

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
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")

    res = resources.reject { |r| r.name == "er_example" }
    res.each do |r|
      venv.pip_install r
    end

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
