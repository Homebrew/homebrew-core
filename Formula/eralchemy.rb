class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/Alexis-benoist/eralchemy"
  url "https://files.pythonhosted.org/packages/de/6c/5a7d4104b51488f2f2f3e23856fec454d6e406d1c69c5754d036a2416f1b/ERAlchemy-1.2.7.tar.gz"
  sha256 "bfca6a6625e8c28af1679614e0d347cfe299f2342191a408c933272b2a88f646"

  bottle do
    cellar :any
    sha256 "267195526e99c8f47abe2ea9d51134e30cf1e3167e9d8d121ff820fa1f97e890" => :high_sierra
    sha256 "683a2b5bd0ecde79890077f7522fb2f7d8f0cacb801cec1143c0eb3c48cee0d1" => :sierra
    sha256 "83d53a6dc644e5e0429901ef04da13744b51c9417c978811246e274bfe5c7da2" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "pkg-config" => :build
  depends_on "graphviz"
  depends_on "openssl"
  depends_on "postgresql" => :optional

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/98/bb/a32e33f7665b921c926209305dde66fe41003a4ad934b10efb7c1211a419/pygraphviz-1.3.1.tar.gz"
    sha256 "7c294cbc9d88946be671cc0d8602aac176d8c56695c0a7d871eadea75a958408"
  end

  resource "SQLAlchemy" do
    url "https://files.pythonhosted.org/packages/f3/b7/d8725042f105cc6b71c7bae0ffd46e49f762e5a08f421f1eddd855a1f723/SQLAlchemy-1.2.4.tar.gz"
    sha256 "6997507af46b10630e13b605ac278b78885fd683d038896dbee0e7ec41d809d2"
  end

  resource "psycopg2" do
    url "https://files.pythonhosted.org/packages/74/83/51580322ed0e82cba7ad8e0af590b8fb2cf11bd5aaa1ed872661bd36f462/psycopg2-2.7.4.tar.gz"
    sha256 "8bf51191d60f6987482ef0cfe8511bbf4877a5aa7f313d7b488b53189cf26209"
  end

  resource "er_example" do
    url "https://raw.githubusercontent.com/Alexis-benoist/eralchemy/v1.1.0/example/newsmeme.er"
    sha256 "5c475bacd91a63490e1cbbd1741dc70a3435e98161b5b9458d195ee97f40a3fa"
  end

  def install
    venv = virtualenv_create(libexec)

    res = resources.map(&:name).to_set - ["er_example", "psycopg2"]

    res.each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install resource("psycopg2") if build.with? "postgresql"

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
