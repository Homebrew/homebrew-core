class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/eralchemy/eralchemy"
  url "https://files.pythonhosted.org/packages/1b/cc/d41f21c662b244efedabac91705834c59dcf43b09e74dbc2b5ff32ea8b1c/eralchemy-1.7.0.tar.gz"
  sha256 "926376fdab2e1ca8eec05698c457d17718ed1458fa574b67e815c43ae52b377a"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "12c93a3c5749cbacdaed82b29d31d1858f5e0a117638c06b45b9c9f8b259523b"
    sha256 cellar: :any, arm64_tahoe:       "5257e0349e7f67325f7d5bb21c96d92991870f365ed09b54255c52192fd3fd67"
    sha256 cellar: :any, arm64_sequoia:     "9bb68943f8fac357629a343914628c41ee84ebb86db9e1822eb37d6250cfec80"
    sha256 cellar: :any, arm64_sonoma:      "0954018789a1495a2e1f79de19ccb793421857a939089243704193335204109e"
    sha256 cellar: :any, arm64_linux:       "40da2e37d5a1b40f8426d3a9cc0050f949be7ca4fdfeca2736772a96503853cc"
    sha256 cellar: :any, x86_64_linux:      "8fdc3fa45428de10c02bcd34ee699096dc9ca59119bae95074274865442852c4"
  end

  depends_on "pkgconf" => :build
  depends_on "graphviz"
  depends_on "libpq"
  depends_on "openssl@3"
  depends_on "python@3.14"

  pypi_packages package_name: "eralchemy[pygraphviz]"

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/3c/3f/dbf99fb14bfeb88c28f16729215478c0e265cacd6dc22270c8f31bb6892f/greenlet-3.5.0.tar.gz"
    sha256 "d419647372241bc68e957bf38d5c1f98852155e4146bd1e4121adea81f4f01e4"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/66/ca/823d5c74a73d6b8b08e1f5aea12468ef334f0732c65cbb18df2a7f285c87/pygraphviz-1.14.tar.gz"
    sha256 "c10df02377f4e39b00ae17c862f4ee7e5767317f1c6b2dfd04cea6acc7fc2bea"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/09/45/461788f35e0364a8da7bda51a1fe1b09762d0c32f12f63727998d85a873b/sqlalchemy-2.0.49.tar.gz"
    sha256 "d15950a57a210e36dd4cec1aac22787e2a4d57ba9318233e2ef8b2daf9ff2d5f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "er_example" do
      url "https://raw.githubusercontent.com/Alexis-benoist/eralchemy/refs/tags/v1.1.0/example/newsmeme.er"
      sha256 "5c475bacd91a63490e1cbbd1741dc70a3435e98161b5b9458d195ee97f40a3fa"
    end

    system bin/"eralchemy", "-v"
    resource("er_example").stage do
      system bin/"eralchemy", "-i", "newsmeme.er", "-o", "test_eralchemy.pdf"
      assert_path_exists Pathname.pwd/"test_eralchemy.pdf"
    end
  end
end
