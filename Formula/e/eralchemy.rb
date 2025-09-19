class Eralchemy < Formula
  include Language::Python::Virtualenv

  desc "Simple entity relation (ER) diagrams generation"
  homepage "https://github.com/eralchemy/eralchemy"
  url "https://files.pythonhosted.org/packages/0e/c0/9c28acf903566a02de43f8fc6c572b8195ab0fa854016825e5690c77b57a/eralchemy-1.6.0.tar.gz"
  sha256 "8f82d329ec0cd9c04469adf36b8889b5ea2583e7e53c0fd2e784e176e1e27c7a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b73a054d94feeb9cfb690124d22a98362f92ab00d5eeede5e8e21026a721f262"
    sha256 cellar: :any,                 arm64_sequoia: "7c9320fb74e503c7351b505248ecb958ae6513a7e2e6f9d4373655340d5e69b6"
    sha256 cellar: :any,                 arm64_sonoma:  "ad76090e5129b0242da09b1803f72eab996be0e3d85517d4d5c81161046075c0"
    sha256 cellar: :any,                 sonoma:        "1f28d88544a49dc6762d9b244c870c8c8a318a95ceee14d45fcb7adecccb2d4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08895664489bd7834de2789ff18e71e8125b56d84c282bb65a004b5a9adb812d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad6928bf661621669f18a119165f256aa57dec4f50ae66eb18544dda58640fa8"
  end

  depends_on "pkgconf" => :build
  depends_on "graphviz"
  depends_on "libpq"
  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/03/b8/704d753a5a45507a7aab61f18db9509302ed3d0a27ac7e0359ec2905b1a6/greenlet-3.2.4.tar.gz"
    sha256 "0dca0d95ff849f9a364385f36ab49f50065d76964944638be9691e1832e9f86d"
  end

  resource "pygraphviz" do
    url "https://files.pythonhosted.org/packages/66/ca/823d5c74a73d6b8b08e1f5aea12468ef334f0732c65cbb18df2a7f285c87/pygraphviz-1.14.tar.gz"
    sha256 "c10df02377f4e39b00ae17c862f4ee7e5767317f1c6b2dfd04cea6acc7fc2bea"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/d7/bc/d59b5d97d27229b0e009bd9098cd81af71c2fa5549c580a0a67b9bed0496/sqlalchemy-2.0.43.tar.gz"
    sha256 "788bfcef6787a7764169cfe9859fe425bf44559619e1d9f56f5bddf2ebf6f417"
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
