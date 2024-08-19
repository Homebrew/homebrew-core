class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/eralchemy/eralchemy"
  url "https://files.pythonhosted.org/packages/87/40/07b58c29406ad9cc8747e567e3e37dd74c0a8756130ad8fd3a4d71c796e3/ERAlchemy-1.2.10.tar.gz"
  sha256 "be992624878278195c3240b90523acb35d97453f1a350c44b4311d4333940f0d"
  license "Apache-2.0"
  revision 7

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "367acd7b96563e4125df8898bc2f1cb07b229bbbb04b78a321b19e1fc8c789b1"
    sha256 cellar: :any,                 arm64_ventura:  "9c97192396a1913523c7cfc518ee6992bd19190ffe648b015984f5783a026ecf"
    sha256 cellar: :any,                 arm64_monterey: "697bcb5c3612f600fa6c4792eb54ae3598478159c353d6bc727f5f5c59a3cdfe"
    sha256 cellar: :any,                 sonoma:         "7d08e2b884b797dfac455c6a727e51170d6391784bb05df88068aa9be781475a"
    sha256 cellar: :any,                 ventura:        "971c788786605ca57de3a4703ae9d6bf5769cab7cb3f4eeda30717edb0b14d23"
    sha256 cellar: :any,                 monterey:       "b692bdfec78085160b99b0c0b985513ac9be3a7186f8c13271e562c073d6c295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aa0e534f282e2a530f99e14caceced86c646d818a2092cd07d523bdb244e29d"
  end

  depends_on "pkg-config" => :build
  depends_on "graphviz"
  depends_on "libpq"
  depends_on "openssl@3"
  depends_on "python@3.12"

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/f0/2a/3a7e5f6ba25c0a8998ded9234127c88c5c867bd03cfc3a7b18ef00876599/pygraphviz-1.12.tar.gz"
    sha256 "8b0b9207954012f3b670e53b8f8f448a28d12bdbbcf69249313bd8dbe680152f"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/b9/fc/327f0072d1f5231d61c715ad52cb7819ec60f0ac80dc1e507bc338919caa/SQLAlchemy-2.0.27.tar.gz"
    sha256 "86a6ed69a71fe6b88bf9331594fa390a2adda4a49b5c06f98e47bf0d392534f8"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "er_example" do
      url "https://raw.githubusercontent.com/Alexis-benoist/eralchemy/v1.1.0/example/newsmeme.er"
      sha256 "5c475bacd91a63490e1cbbd1741dc70a3435e98161b5b9458d195ee97f40a3fa"
    end

    system bin/"eralchemy", "-v"
    resource("er_example").stage do
      system bin/"eralchemy", "-i", "newsmeme.er", "-o", "test_eralchemy.pdf"
      assert_predicate Pathname.pwd/"test_eralchemy.pdf", :exist?
    end
  end
end
