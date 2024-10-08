class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/eralchemy/eralchemy"
  url "https://files.pythonhosted.org/packages/19/05/5f69930e83a02360d9ed16660bdd58d9d501bffabd43d7dbbe8c14269143/eralchemy-1.5.0.tar.gz"
  sha256 "fa66a3cd324abd27ad8e65908d7af48d8198c0c185aeb22189cf40516de25941"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d452d498ff2c9ad70a113315111586eb97087ad72efabc9f11d1d1a02387ceca"
    sha256 cellar: :any,                 arm64_sonoma:  "e055bcdd47c8969f7cfcfa2a91f98790e67be7ec5988a6c30d2c5594ac6b2f79"
    sha256 cellar: :any,                 arm64_ventura: "f72636b38733fa8a0e7fa45321e3b7d0b5632932be0d5c4874e8285ade43bcf4"
    sha256 cellar: :any,                 sonoma:        "8141288b90a807f7fa65b45264525b3d3431bdbb977b61e22e8eb00cd43aaa46"
    sha256 cellar: :any,                 ventura:       "27eeaec09061fe0ac139c6abd239a8c876b35a8d3cb542d9efc9e18c17f636f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33e02d317b404340e438a30ad0845114e11976856db134e76ff4ac7fcf6a99b0"
  end

  depends_on "pkg-config" => :build
  depends_on "graphviz"
  depends_on "libpq@17"
  depends_on "openssl@3"
  depends_on "python@3.12"

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/8c/41/7b9a22df38bb7884012b34f2986d765691dbe41bf5e7af881dfd09f8145f/pygraphviz-1.13.tar.gz"
    sha256 "6ad8aa2f26768830a5a1cfc8a14f022d13df170a8f6fdfd68fd1aa1267000964"
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
      assert_predicate Pathname.pwd/"test_eralchemy.pdf", :exist?
    end
  end
end
