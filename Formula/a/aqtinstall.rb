class Aqtinstall < Formula
  include Language::Python::Virtualenv

  desc "Another unofficial Qt installer"
  homepage "https://github.com/miurahr/aqtinstall"
  url "https://files.pythonhosted.org/packages/76/19/24a588de6c25d43169d172dab47e63a63cd0d8f90e98cf86487acbf00ac7/aqtinstall-3.3.0.tar.gz"
  sha256 "9c7d85fbe7258be2d7d23fda33f8aff2e8b7536817255eaeaaf4226da8546a31"
  license "MIT"
  revision 5
  head "https://github.com/miurahr/aqtinstall.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72ea2a7cc474aa9f230a2d0dd443c4724eab1e1d368ca9ac13d87872af47670c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3d4e4c17fc74253fff4789e0c16282d277bb09569e9e98d65c80e9c60b087e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d58f3908fd9c69fefa5eea8dd82ae0100a349f54b9fed4709faf5e4b65509c53"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dfc9f111eee0f13a14c203d2ba5f1117a867228332e93ec57d9c7081cc606db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2385771954909c0a7188a3279e61d203785ea8eb5f46b29b988f2fac9d779875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a71594666ae2e3e252a9d21b6811842252a071fd92d5fe59cfe4fbd9eda4067c"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c3/b0/1c6a16426d389813b48d95e26898aff79abbde42ad353958ad95cc8c9b21/beautifulsoup4-4.14.3.tar.gz"
    sha256 "6292b1c5186d356bba669ef9f7f051757099565ad9ada5dd630bd9de5fa7fb86"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/c9/aa/4acaf814ff901145da37332e05bb510452ebed97bc9602695059dd46ef39/bs4-0.0.2.tar.gz"
    sha256 "a48685c58f50fe127722417bae83fe6badf500d54b55f7e39ffe43b798653925"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/ba/66/a3921783d54be8a6870ac4ccffcd15c4dc0dd7fcce51c6d63b8c63935276/humanize-4.15.0.tar.gz"
    sha256 "1dd098483eb1c7ee8e32eb2e99ad1910baefa4b75c3aff3a82f4d78688993b10"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "inflate64" do
    url "https://files.pythonhosted.org/packages/3e/f3/41bb2901543abe7aad0b0b0284ae5854bb75f848cf406bf8a046bf525f67/inflate64-1.0.4.tar.gz"
    sha256 "b398c686960c029777afc0ed281a86f66adb956cfc3fbf6667cc6453f7b407ce"
  end

  resource "multivolumefile" do
    url "https://files.pythonhosted.org/packages/50/f0/a7786212b5a4cb9ba05ae84a2bbd11d1d0279523aea0424b6d981d652a14/multivolumefile-0.2.3.tar.gz"
    sha256 "a0648d0aafbc96e59198d5c17e9acad7eb531abea51035d08ce8060dcad709d6"
  end

  resource "patch-ng" do
    url "https://files.pythonhosted.org/packages/65/bb/ebd7c6058dcfbf634986f9a8b3fb638f3269501c73701a48b7530042da5b/patch-ng-1.19.0.tar.gz"
    sha256 "27484792f4ac1c15fe2f3e4cecf74bb9833d33b75c715b71d199f7e1e7d1f786"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/73/cb/09e5184fb5fc0358d110fc3ca7f6b1d033800734d34cac10f4136cfac10e/psutil-7.2.1.tar.gz"
    sha256 "f7583aec590485b43ca601dd9cea0dcd65bd7bb21d30ef4ddbf4ea6b5ed1bdd3"
  end

  resource "py7zr" do
    url "https://files.pythonhosted.org/packages/0c/e6/01fb15361ca75ee5d01df6361825a49816a836c99980c5481da0e40c6877/py7zr-1.1.0.tar.gz"
    sha256 "087b1a94861ad9eb4d21604f6aaa0a8986a7e00580abd79fedd6f82fecf0592c"
  end

  resource "pybcj" do
    url "https://files.pythonhosted.org/packages/12/0c/2670b672655b18454841b8e88f024b9159d637a4c07f6ce6db85accf8467/pybcj-1.0.7.tar.gz"
    sha256 "72d64574069ffb0a800020668376b7ebd7adea159adbf4d35f8effc62f0daa67"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pyppmd" do
    url "https://files.pythonhosted.org/packages/81/d7/803232913cab9163a1a97ecf2236cd7135903c46ac8d49613448d88e8759/pyppmd-1.3.1.tar.gz"
    sha256 "ced527f08ade4408c1bfc5264e9f97ffac8d221c9d13eca4f35ec1ec0c7b6b2e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/89/23/adf3796d740536d63a6fbda113d07e60c734b6ed5d3058d1e47fc0495e47/soupsieve-2.8.1.tar.gz"
    sha256 "4cf733bc50fa805f5df4b8ef4740fc0e0fa6218cf3006269afd3f9d6d80fd350"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/1c/dc/0aff23d6036a4d3bf4f1d8c8204c5c79c4437e25e0ae94ffe4bbb55ee3c2/texttable-1.7.0.tar.gz"
    sha256 "2d2068fb55115807d3ac77a4ca68fa48803e84ebb0ee2340f858107a36522638"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "clang_64", shell_output("#{bin}/aqt list-qt mac desktop --arch 6.7.0")
    assert_match "linux_gcc_64", shell_output("#{bin}/aqt list-qt linux desktop --arch 6.7.0")
  end
end
