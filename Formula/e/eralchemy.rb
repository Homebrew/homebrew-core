class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/eralchemy/eralchemy"
  url "https://files.pythonhosted.org/packages/19/05/5f69930e83a02360d9ed16660bdd58d9d501bffabd43d7dbbe8c14269143/eralchemy-1.5.0.tar.gz"
  sha256 "fa66a3cd324abd27ad8e65908d7af48d8198c0c185aeb22189cf40516de25941"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "92ec126756fb9a9a3b483d2a5c7ea2487e07c16ca357f5d386f1c206a761c2b3"
    sha256 cellar: :any,                 arm64_sonoma:  "6fbb9351b85cbb0f7a3b3416201820a4f39dffb0f7d07e9585c185c48fd16673"
    sha256 cellar: :any,                 arm64_ventura: "30f822ebe671d6ca630435f0a5a91bf561edaa26fa650c69047991ba19b56257"
    sha256 cellar: :any,                 sonoma:        "ef8c1526f85a9c1ffbf2b4ad0fc02e8979fb149873761feba5dd3b0232e9bc8b"
    sha256 cellar: :any,                 ventura:       "1991afedef5dc1bfcb529e2c6c38c47734f83a5b6585bb5424eb7a3f994fa879"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bceb9011707597662091f77a43f3e192b53ed5490c971b77126ef0b0ad94ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed03f3df61c850f93cbb16b1f06c25cd586c92164594e49803bc69565cc2e432"
  end

  depends_on "pkgconf" => :build
  depends_on "graphviz"
  depends_on "libpq"
  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/66/ca/823d5c74a73d6b8b08e1f5aea12468ef334f0732c65cbb18df2a7f285c87/pygraphviz-1.14.tar.gz"
    sha256 "c10df02377f4e39b00ae17c862f4ee7e5767317f1c6b2dfd04cea6acc7fc2bea"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/36/48/4f190a83525f5cefefa44f6adc9e6386c4de5218d686c27eda92eb1f5424/sqlalchemy-2.0.35.tar.gz"
    sha256 "e11d7ea4d24f0a262bccf9a7cd6284c976c5369dac21db237cff59586045ab9f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
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
      assert_path_exists Pathname.pwd/"test_eralchemy.pdf"
    end
  end
end
