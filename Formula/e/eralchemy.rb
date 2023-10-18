class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/Alexis-benoist/eralchemy"
  url "https://files.pythonhosted.org/packages/87/40/07b58c29406ad9cc8747e567e3e37dd74c0a8756130ad8fd3a4d71c796e3/ERAlchemy-1.2.10.tar.gz"
  sha256 "be992624878278195c3240b90523acb35d97453f1a350c44b4311d4333940f0d"
  license "Apache-2.0"
  revision 7

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "a6ed7900c4ae0d86c0367a73d0ff6347b0d4926c1b5e7ff55585392749564758"
    sha256 cellar: :any,                 arm64_ventura:  "07ddc38eec10f049dfc18f65a158110bba687de240a6019a98a79a1cd19bb346"
    sha256 cellar: :any,                 arm64_monterey: "e45387cbdc1de739e84583380009217fe11afdd30afb49bac433760bb8e1b0d6"
    sha256 cellar: :any,                 sonoma:         "acb34ace16cfeaeee0dbb47d5dcb7048aacced1f1d4c6904eab4b4d8c0cc9bf3"
    sha256 cellar: :any,                 ventura:        "12ab1b4d747e635bb747b087e989b29c967eee5eab308af169d05a20d5616122"
    sha256 cellar: :any,                 monterey:       "d7a3ef294cc855950faf77b476f3ff424559fbcbffae08dc32e6af938a81cd57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5593d71ebe46e3ddeef556375e808b01f9cba7726c61fb7ea7d00e7a825bd725"
  end

  depends_on "pkg-config" => :build
  depends_on "graphviz"
  depends_on "libpq"
  depends_on "openssl@3"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/19/db/cc09516573e79a35ac73f437bdcf27893939923d1d06b439897ffc7f3217/pygraphviz-1.11.zip"
    sha256 "a97eb5ced266f45053ebb1f2c6c6d29091690503e3a5c14be7f908b37b06f2d4"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/ae/e2/47f40dc06472df5a906dd8eb9fe4ee2eb1c6b109c43545708f922b406acc/SQLAlchemy-2.0.22.tar.gz"
    sha256 "5434cc601aa17570d79e5377f5fd45ff92f9379e2abed0be5e8c2fba8d353d2b"
  end

  resource "er_example" do
    url "https://raw.githubusercontent.com/Alexis-benoist/eralchemy/v1.1.0/example/newsmeme.er"
    sha256 "5c475bacd91a63490e1cbbd1741dc70a3435e98161b5b9458d195ee97f40a3fa"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
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
