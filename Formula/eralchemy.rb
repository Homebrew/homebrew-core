class Eralchemy < Formula
  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/Alexis-benoist/eralchemy"
  url "https://pypi.python.org/packages/source/E/ERAlchemy/ERAlchemy-1.0.1.tar.gz"
  sha256 "98425b21fe0f12ff33e72789c8a308baa1c2d5fdf157388162deaa510551da4f"
  revision 1

  bottle do
    cellar :any
    sha256 "cfdc556c98b2d81d8627d4614183f2964abd53c2838205f5831982ff061a83db" => :el_capitan
    sha256 "176f5a19c8b68d7eeec32fe3f36d53798ec99736c14a02f835590100af905ddd" => :yosemite
    sha256 "755bdac7cf8a455170209f3ad60be836ef6502c59268d39a8d764c5e750b5374" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pkg-config" => :build
  depends_on "graphviz"
  depends_on "openssl"
  depends_on :postgresql => :optional

  resource "pygraphviz" do
    url "https://pypi.python.org/packages/source/p/pygraphviz/pygraphviz-1.3.1.tar.gz"
    sha256 "7c294cbc9d88946be671cc0d8602aac176d8c56695c0a7d871eadea75a958408"
  end

  resource "SQLAlchemy" do
    url "https://pypi.python.org/packages/source/S/SQLAlchemy/SQLAlchemy-1.0.11.tar.gz"
    sha256 "0b24729787fa1455009770880ea32b1fa5554e75170763b1aef8b1eb470de8a3"
  end

  resource "psycopg2" do
    url "https://pypi.python.org/packages/source/p/psycopg2/psycopg2-2.6.1.tar.gz"
    sha256 "6acf9abbbe757ef75dc2ecd9d91ba749547941abaffbe69ff2086a9e37d4904c"
  end

  resource "er_example" do
    url "https://raw.githubusercontent.com/Alexis-benoist/eralchemy/v1.0.1/example/newsmeme.er"
    sha256 "5c475bacd91a63490e1cbbd1741dc70a3435e98161b5b9458d195ee97f40a3fa"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[pygraphviz SQLAlchemy].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    if build.with?("postgresql")
      resource("psycopg2").stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/eralchemy", "-v"
    resource("er_example").stage do
      system "#{bin}/eralchemy", "-i", "newsmeme.er", "-o", "test_eralchemy.pdf"
      assert File.exist?("test_eralchemy.pdf")
    end
  end
end
