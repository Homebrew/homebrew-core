class Bilix < Formula
  include Language::Python::Virtualenv

  desc "Lightning-fast asynchronous download tool for bilibili and more"
  homepage "https://github.com/HFrost0/bilix"
  url "https://files.pythonhosted.org/packages/08/de/f349e3a5571613b39f109247c07f9f9b493ad4fd5ae4c42301210574885a/bilix-0.18.7.tar.gz"
  sha256 "d39543a2198c3e6218d674fb83fea0b62a5c98224609828abffbec018ea2cc20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0fbe3920c7ac40b28777a160e05938204ecbcfe448cc00b2971f2cd2efbaa9f3"
    sha256 cellar: :any,                 arm64_ventura:  "3169c1e19c95b48ec032f6a44e33bbd498628cdff90e4d15eaf96b95c6445dd5"
    sha256 cellar: :any,                 arm64_monterey: "11403ebbeaedfc0175942f189007fcb52667de3f6ba5ff3fa76fb6b3fb215111"
    sha256 cellar: :any,                 sonoma:         "367af61e7efeb3dd5b4e9e675156ca6be172388ba603f02b99f061484e9364b4"
    sha256 cellar: :any,                 ventura:        "22ecc8343c46131f2528a8428d7549326144501fb70aa3c5918f8f4d3cc51648"
    sha256 cellar: :any,                 monterey:       "f865fbe3fbc78d651c6510faaf1bf7d6b025d4cd2a4eb4a171be03224b498b35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cf938827dd23b01d1aa634e3e97728c91e5da957bbb7a9750266c63c8f29446"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/af/41/cfed10bc64d774f497a86e5ede9248e1d062db675504b41c320954d99641/aiofiles-23.2.1.tar.gz"
    sha256 "84ec2218d8419404abcb9f0c02df3f34c6e0a68ed41072acfb1cef5cbc29051a"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/2d/b8/7333d87d5f03247215d86a86362fd3e324111788c6cdd8d2e6196a6ba833/anyio-4.2.0.tar.gz"
    sha256 "e1875bb4b4e2de1669f4bc7869b6d3f54231cdced71605e6e64c9be77e3be50f"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "browser-cookie3" do
    url "https://files.pythonhosted.org/packages/27/74/38bce788694ab4db1f91b729d782e85fefe855ccd1a5f74ee03e6ac43008/browser-cookie3-0.19.1.tar.gz"
    sha256 "3031ad14b96b47ef1e4c8545f2f463e10ad844ef834dcd0ebdae361e31c6119a"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/c9/aa/4acaf814ff901145da37332e05bb510452ebed97bc9602695059dd46ef39/bs4-0.0.2.tar.gz"
    sha256 "a48685c58f50fe127722417bae83fe6badf500d54b55f7e39ffe43b798653925"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/b6/2c/66bab4fef920ef8caa3e180ea601475b2cbbe196255b18f1c58215940607/construct-2.8.8.tar.gz"
    sha256 "1b84b8147f6fd15bcf64b737c3e8ac5100811ad80c830cb4b2545140511c4157"
  end

  resource "danmakuc" do
    url "https://files.pythonhosted.org/packages/f5/81/171b7d5706546d7bd9dd431589e384f65d3007bb7bcb1475e3c677d7e243/danmakuC-0.3.6.tar.gz"
    sha256 "db6b7dcf3dba1595c08a37a6f27f925fb40b9b8c110ff013872ac575c9c30132"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/2a/32/fec683ddd10629ea4ea46d206752a95a2d8a48c22521edd70b142488efe1/h2-4.1.0.tar.gz"
    sha256 "a83aca08fbe7aacb79fec788c9c0bac936343560ed9ec18b82a13a12c28d2abb"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/3e/9b/fda93fb4d957db19b0f6b370e79d586b3e8528b20252c729c476a2c02954/hpack-4.0.0.tar.gz"
    sha256 "fc41de0c63e687ebffde81187a948221294896f6bdc0ae2312708df339430095"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/18/56/78a38490b834fa0942cbe6d39bd8a7fd76316e8940319305a98d2b320366/httpcore-1.0.2.tar.gz"
    sha256 "9fc092e4799b26174648e54b74ed5f683132a464e95643b226e00c2ed2fa6535"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/bd/26/2dc654950920f499bd062a211071925533f821ccdca04fa0c2fd914d5d06/httpx-0.26.0.tar.gz"
    sha256 "451b55c30d5185ea6b23c2c793abf9bb237d2a7dfb901ced6ff69ad37ec1dfaf"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/5a/2a/4747bff0a17f7281abe73e955d60d80aae537a5d203f417fa1c2e7578ebb/hyperframe-6.0.1.tar.gz"
    sha256 "ae510046231dc8e9ecb1a6586f63d2347bf4c8905914aa84ba585ae85f28a914"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/f9/40/89e0ecbf8180e112f22046553b50a99fdbb9e8b7c49d547cda2bfa81097b/json5-0.9.14.tar.gz"
    sha256 "9ed66c3a6ca3510a976a9ef9b8c0787de24802724ab1860bc0153c7fdd589b02"
  end

  resource "lz4" do
    url "https://files.pythonhosted.org/packages/a4/31/ec1259ca8ad11568abaf090a7da719616ca96b60d097ccc5799cd0ff599c/lz4-4.3.3.tar.gz"
    sha256 "01fe674ef2889dbb9899d8a67361e0c4a2c833af5aeb37dd505727cf5d2a131e"
  end

  resource "m3u8" do
    url "https://files.pythonhosted.org/packages/d4/f3/10e8d8879f284c17ea658a9ddca3b4f9958697d8fd3e50d149133f2a3dc7/m3u8-4.0.0.tar.gz"
    sha256 "32cb3300c702e802944427ecefbe5006e09f7fb5578334ce33f01e2e4bf05470"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/db/a5/05ea470f4e793c9408bc975ce1c6957447e3134ce7f7a58c13be8b2c216f/protobuf-4.25.2.tar.gz"
    sha256 "fe599e175cb347efc8ee524bcd4b902d11f7262c0e569ececcb89995c15f0a5e"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b9/ed/19223a0a0186b8a91ebbdd2852865839237a21c74f1fbc4b8d5b62965239/pycryptodome-3.20.0.tar.gz"
    sha256 "09609209ed7de61c2b560cc5c8c4fbf892f8b15b1faf7e4cbffac97db1fffda7"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/31/a4/b03a16637574312c1b54c55aedeed8a4cb7d101d44058d46a0e5706c63e1/pycryptodomex-3.20.0.tar.gz"
    sha256 "7a710b79baddd65b806402e14766c721aee8fb83381769c27920f26476276c1e"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/aa/3f/56142232152145ecbee663d70a19a45d078180633321efb3847d2562b490/pydantic-2.5.3.tar.gz"
    sha256 "b3ef57c62535b0941697cce638c08900d87fcb67e29cfa99e8a68f747f393f7a"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/b2/7d/8304d8471cfe4288f95a3065ebda56f9790d087edc356ad5bd83c89e2d79/pydantic_core-2.14.6.tar.gz"
    sha256 "1fd0c1d395372843fba13a51c28e3bb9d59bd7aebfeb17358ffaaa1e4dbbe948"
  end

  resource "pymp4" do
    url "https://files.pythonhosted.org/packages/a5/46/dfb3f5363fc71adaf419147fdcb93341029ca638634a5cc6f7e7446416b2/pymp4-1.4.0.tar.gz"
    sha256 "bc9e77732a8a143d34c38aa862a54180716246938e4bf3e07585d19252b77bb5"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  # fix pydantic validation error, remove in next release
  patch do
    url "https://github.com/HFrost0/bilix/commit/c4c2e6d9e8c9383acdb4c1f3f72a7c4d3e251664.patch?full_index=1"
    sha256 "43beb93cfdfe6e0219d7eeb7ad208c3adc60178088950e69ee7698e2d5991a69"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # By pass linux CI test due to the networking issue for `bilix info`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"bilix", "info", "https://www.bilibili.com/video/av20203945/"
  end
end
