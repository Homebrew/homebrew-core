class Aqtinstall < Formula
  include Language::Python::Virtualenv

  desc "Another unofficial Qt installer"
  homepage "https://github.com/miurahr/aqtinstall"
  url "https://files.pythonhosted.org/packages/76/19/24a588de6c25d43169d172dab47e63a63cd0d8f90e98cf86487acbf00ac7/aqtinstall-3.3.0.tar.gz"
  sha256 "9c7d85fbe7258be2d7d23fda33f8aff2e8b7536817255eaeaaf4226da8546a31"
  license "MIT"
  revision 7
  head "https://github.com/miurahr/aqtinstall.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78958b0b34e7c9b9639570aadda480997865b61ed163a253088f76c42411c8c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1204c2678c20db273582de0d471b597ad800575bcd171a3221565a8d0e27477"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80982b4f61f509ddfa22d722932e1d63504905c721448b2184b02ed6d5628dec"
    sha256 cellar: :any_skip_relocation, sonoma:        "849a284c5dc165cffbaf06323c45bb2daac4c8a5427943433a0b77f54220c71e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b5c1bb460fbc72381c035b41eb1f40b33187afa41ad09e7851dab5e8df327e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "224cdfdc5cc33b3a5ac18fc4381bca1b08a774ebe6cee4a435ee8f0675e85f6b"
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
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
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
    url "https://files.pythonhosted.org/packages/05/b1/efac073e0c297ecf2fb33c346989a529d4e19164f1759102dee5953ee17e/idna-3.14.tar.gz"
    sha256 "466d810d7a2cc1022bea9b037c39728d51ae7dad40d480fc9b7d7ecf98ba8ee3"
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
    url "https://files.pythonhosted.org/packages/da/b6/8ea8095f964f93567bbe28709298b30104ad418b50d4217538387bf48f7d/patch_ng-1.19.1.tar.gz"
    sha256 "036a3cc00134ec53f37e92333958ee75e117f2e62a5ec2b85c7122e5e815c29e"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
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
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/7b/ae/2d9c981590ed9999a0d91755b47fc74f74de286b0f5cee14c9269041e6c4/soupsieve-2.8.3.tar.gz"
    sha256 "3267f1eeea4251fb42728b6dfb746edc9acaffc4a45b27e19450b676586e8349"
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
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "clang_64", shell_output("#{bin}/aqt list-qt mac desktop --arch 6.7.0")
    assert_match "linux_gcc_64", shell_output("#{bin}/aqt list-qt linux desktop --arch 6.7.0")
  end
end
