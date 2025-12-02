class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/eralchemy/eralchemy"
  url "https://files.pythonhosted.org/packages/0e/c0/9c28acf903566a02de43f8fc6c572b8195ab0fa854016825e5690c77b57a/eralchemy-1.6.0.tar.gz"
  sha256 "8f82d329ec0cd9c04469adf36b8889b5ea2583e7e53c0fd2e784e176e1e27c7a"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "49a346cfaa425cda1007f4fc5cccca83546f2297770cb007d63d9f3b0f84e2e6"
    sha256 cellar: :any,                 arm64_sequoia: "1ee8ae85a57cbceefb97b74b20b7471e107569152e7bb44708e9a44398a7ddb0"
    sha256 cellar: :any,                 arm64_sonoma:  "7d5f1101a875838e742fb2649d37be7e22705606ee1b3256117cd8e82a000d5b"
    sha256 cellar: :any,                 sonoma:        "d8d2db3e30495966876ddd5e78cd9105333ce3d89f88b71515a87eca3997b051"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c79fa38699df65ebad7ff99554d7775d9fe5b91a4a5c94e0ceccce3a2663d2d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17c170fcb2656f9089d5142b82ca21c6b9b2793cadd458505714b65803b237c9"
  end

  depends_on "pkgconf" => :build
  depends_on "graphviz"
  depends_on "libpq"
  depends_on "openssl@3"
  depends_on "python@3.14"

  pypi_packages package_name: "eralchemy[pygraphviz]"

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/66/ca/823d5c74a73d6b8b08e1f5aea12468ef334f0732c65cbb18df2a7f285c87/pygraphviz-1.14.tar.gz"
    sha256 "c10df02377f4e39b00ae17c862f4ee7e5767317f1c6b2dfd04cea6acc7fc2bea"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/f0/f2/840d7b9496825333f532d2e3976b8eadbf52034178aac53630d09fe6e1ef/sqlalchemy-2.0.44.tar.gz"
    sha256 "0ae7454e1ab1d780aee69fd2aae7d6b8670a581d8847f2d1e0f7ddfbf47e5a22"
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
