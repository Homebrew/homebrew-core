class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/Alexis-benoist/eralchemy"
  url "https://files.pythonhosted.org/packages/87/40/07b58c29406ad9cc8747e567e3e37dd74c0a8756130ad8fd3a4d71c796e3/ERAlchemy-1.2.10.tar.gz"
  sha256 "be992624878278195c3240b90523acb35d97453f1a350c44b4311d4333940f0d"
  license "Apache-2.0"
  revision 6

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "90c54e151e6f6a65d761bc571c32ef9add975cff7503efa7a24a725e8fd3da8d"
    sha256 cellar: :any,                 arm64_monterey: "ecbfa57048711bf1cbfd0f67f55e1bd7f8b13fae8302826dcd794a8c4010ec01"
    sha256 cellar: :any,                 arm64_big_sur:  "0a9a6d6ce98d3d19315ec3cb0e810a14aba6feff359c3ae54e83c9b93caa94e0"
    sha256 cellar: :any,                 ventura:        "c3b0e88597a3e45526fde52fa0f819b6394ccc40d205a9b3ce23e09069addaaa"
    sha256 cellar: :any,                 monterey:       "65b851f69ab987e5d8cc2182c136fdfc39b45fcc2ceaa9dbcf5eec84e2267edc"
    sha256 cellar: :any,                 big_sur:        "0cbb8202c92ed769fc0ad59c2355ecafaa5a07e3b1d2c98394f2af55c76fd4cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1360dcd9c43951db50971b9942b62043d45165a7dddc8c5205c57d1490170665"
  end

  depends_on "pkg-config" => :build
  depends_on "graphviz"
  depends_on "libpq"
  depends_on "openssl@1.1"
  depends_on "python@3.11"

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
    venv = virtualenv_create(libexec, "python3.11")
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
