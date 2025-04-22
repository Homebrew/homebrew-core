class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/09/a9/d1ae2b45e798593b31fcc2a9f9aa91df169c8592f03fdddbc0a2a1037f21/nvchecker-2.17.tar.gz"
  sha256 "06995aec5a5e81e8ac19796741095609916b6f5bea46dd803e0b0aedb4fa2fb6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c75e3685064ce5156714f628fd0a778ac51d9f5a3df9971073eaccf9df910475"
    sha256 cellar: :any,                 arm64_sonoma:  "0bdcef43afc810b011ba8d26bc73c6c2f5f335fd991d390313fe5161a88430c2"
    sha256 cellar: :any,                 arm64_ventura: "b1e3b628d384309fce5cd6c696855ecbb4e98c6cc394f8464afafaa58fc408a9"
    sha256 cellar: :any,                 sonoma:        "f3c1c657166a0e5b205bd0f77afb03742a9547f444950eb8953c79ebcbc92aa0"
    sha256 cellar: :any,                 ventura:       "ca5c0620d36e8944cc21d3ec4ebd39a038f1d40e883b59a945b6b596a41796ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5ae6c723086420d4ec8fe1908f38564a1201a7d2a91490981de2de313692773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "626bf81b2fd4f36f58e9ea5d5cc2058c9bc778d2f877de91913048c4a2493bad"
  end

  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/71/35/fe5088d914905391ef2995102cf5e1892cf32cab1fa6ef8130631c89ec01/pycurl-7.45.6.tar.gz"
    sha256 "2b73e66b22719ea48ac08a93fc88e57ef36d46d03cb09d972063c9aa86bb74e6"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/78/b8/d3670aec25747e32d54cd5258102ae0d69b9c61c79e7aa326be61a570d0d/structlog-25.2.0.tar.gz"
    sha256 "d9f9776944207d1035b8b26072b9b140c63702fd7aa57c2f85d28ab701bd8e92"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/59/45/a0daf161f7d6f36c3ea5fc0c2de619746cc3dd4c76402e9db545bd920f63/tornado-6.4.2.tar.gz"
    sha256 "92bad5b4746e9879fd7bf1eb21dce4e3fc5128d71601f80005afa39237ad620b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~TOML
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    TOML

    output = JSON.parse(shell_output("#{bin}/nvchecker -c #{file} --logger=json"))
    assert_equal version.to_s, output["version"]
  end
end
