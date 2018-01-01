class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/Alexis-benoist/eralchemy"
  url "https://files.pythonhosted.org/packages/f8/84/a7e4b73a427425e8d2d0446b6e94320e7ab4c44abe29c66150a7ee14f981/ERAlchemy-1.1.0.tar.gz"
  sha256 "29ed9d0b865196e428955a3e9f1e1ce4a8e2ce2855aa58f6aaab97991e8407ba"

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
    url "https://files.pythonhosted.org/packages/24/de/66d96cbad7a91443af1399469e9aa0aec8a41669ba6d0faae8b8411ddb27/SQLAlchemy-1.1.6.tar.gz"
    sha256 "815924e3218d878ddd195d2f9f5bf3d2bb39fabaddb1ea27dace6ac27d9865e4"
  end

  resource "psycopg2" do
    url "https://files.pythonhosted.org/packages/62/ca/0a479c9664526e86c2913a7ad593586eeb86b428b7e629e7c7b6b69e3cb7/psycopg2-2.7.tar.gz"
    sha256 "ceadecf660ad4f7a31ea5baef30a7351add8626f9fd3daaafabb9a9e549f3f9a"
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
