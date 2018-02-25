class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/Alexis-benoist/eralchemy"
  url "https://files.pythonhosted.org/packages/2c/58/31393197c1ab3fb8dd7b9c5ee3bd9afe160b8ffc6c870d9d51deca8a76ff/ERAlchemy-1.2.6.tar.gz"
  sha256 "432584a7fd8df0b953f3f90948231382b28727c5364a0a9130c39284b663d9be"

  bottle do
    cellar :any
    sha256 "fec3c64abf16687569a65989cabf5b679b304bed6e3d4500e7473018eb48b463" => :high_sierra
    sha256 "d6f58baabdf8db3224ff90ded790a18d805571e31d4a82c323d6b2b7a5af654c" => :sierra
    sha256 "35b67ce15da8c1189760249239518bcf56332674bf7def6113adcd57b68eb503" => :el_capitan
    sha256 "2b1556bf861cbc976d5eaa6f7cf4282bebf34b9f387dbaa29a7d7e1527a9d344" => :yosemite
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
