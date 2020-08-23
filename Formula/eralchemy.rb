class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/Alexis-benoist/eralchemy"
  url "https://files.pythonhosted.org/packages/87/40/07b58c29406ad9cc8747e567e3e37dd74c0a8756130ad8fd3a4d71c796e3/ERAlchemy-1.2.10.tar.gz"
  sha256 "be992624878278195c3240b90523acb35d97453f1a350c44b4311d4333940f0d"
  license "Apache-2.0"
  revision 3

  bottle do
    cellar :any
    sha256 "197e6d329a91625abe5dfab2858c4e4677e97415a17abcaea18102f252b2ab5b" => :catalina
    sha256 "6d6d3c69a7b5bde65760edd54f7c5507e6021cad0d7388944baf3180cc72647c" => :mojave
    sha256 "e3ffa8878b8c11f2c762709da368a514fedbcbc364b71dd4271093b17a1228c7" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "graphviz"
  depends_on "libpq"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  resource "psycopg2" do
    url "https://files.pythonhosted.org/packages/a8/8f/1c5690eebf148d1d1554fc00ccf9101e134636553dbb75bdfef4f85d7647/psycopg2-2.8.5.tar.gz"
    sha256 "f7d46240f7a1ae1dd95aab38bd74f7428d46531f69219954266d669da60c0818"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/7e/b1/d6d849ddaf6f11036f9980d433f383d4c13d1ebcfc3cd09bc845bda7e433/pygraphviz-1.5.zip"
    sha256 "50a829a305dc5a0fd1f9590748b19fece756093b581ac91e00c2c27c651d319d"
  end

  resource "SQLAlchemy" do
    url "https://files.pythonhosted.org/packages/7f/4b/adfb1f03da7f50db054a5b728d32dbfae8937754cfa159efa0216a3758d1/SQLAlchemy-1.3.16.tar.gz"
    sha256 "7224e126c00b8178dfd227bc337ba5e754b197a3867d33b9f30dc0208f773d70"
  end

  resource "er_example" do
    url "https://raw.githubusercontent.com/Alexis-benoist/eralchemy/v1.1.0/example/newsmeme.er"
    sha256 "5c475bacd91a63490e1cbbd1741dc70a3435e98161b5b9458d195ee97f40a3fa"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")

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
