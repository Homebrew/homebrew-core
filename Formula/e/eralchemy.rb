class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/eralchemy/eralchemy"
  url "https://files.pythonhosted.org/packages/19/05/5f69930e83a02360d9ed16660bdd58d9d501bffabd43d7dbbe8c14269143/eralchemy-1.5.0.tar.gz"
  sha256 "fa66a3cd324abd27ad8e65908d7af48d8198c0c185aeb22189cf40516de25941"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "08649146de0cdf02e659ede3d8a0abcf22ceef117c63df9f556414137f04d692"
    sha256 cellar: :any,                 arm64_sonoma:  "f18d6b415538d24a6777d5589f0a1c36386a541765baef679e9152f36c9d2f47"
    sha256 cellar: :any,                 arm64_ventura: "bcbea307eb470ce0f6a1ed9ec24536e421be304087f58b4669f970a514f33fc6"
    sha256 cellar: :any,                 sonoma:        "285c6bda5678f036aa4315660073df0bd86e68f9a761fe66a5ea4f4a8be3f4bf"
    sha256 cellar: :any,                 ventura:       "90a5befab4b548f14b9a203fd1c802910b9ff3511653d62666f338a814d489b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4eab42a4e1af97949850753589b99b101b5e66c6d2b3fcdc6f6caabec7d388ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3be4ace8ed5abe63973efc16f9c8a88b99a267743d05ae0045ff8d58c841d02e"
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
