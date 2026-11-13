class Bilix < Formula
  include Language::Python::Virtualenv

  desc "Lightning-fast asynchronous download tool for bilibili and more"
  homepage "https://github.com/HFrost0/bilix"
  url "https://files.pythonhosted.org/packages/5c/12/0f885cee77471123a3c82da85bd1934af00aed213910987bbe5b2296997d/bilix-0.18.9.tar.gz"
  sha256 "8ab1be9bcc661369cbeba95439c09716778b6b42b2505a3eaddb45175688e247"
  license "Apache-2.0"
  revision 11
  head "https://github.com/HFrost0/bilix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f7d34db6cc059d4d0174f6315823b3bed04e3cc6a22371bf6e0bb7e732f5e08"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bcb9e7b34492bba2eb1cab625cb07e687c6c6a07eb9fdda46e007f58ac48fbcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ba850cbd45d6aba6953929e7fdf95f172a211656f848c88fef52faeb2481d622"
    sha256 cellar: :any,                 arm64_linux:       "5ca7484be65ceecceb74e0717ad6554a9696af066856ff2212e288a896b28cf0"
    sha256 cellar: :any,                 x86_64_linux:      "95ef7a8cadebe6591813f33d82c564e62ccc4f7d9313dfe7cce7e5384d30b7c7"
  end

  depends_on "cmake" => :build # for danmakuc
  depends_on "certifi" => :no_linkage
  depends_on "lz4"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"

  pypi_packages exclude_packages: ["certifi", "pydantic"]

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/41/c3/534eac40372d8ee36ef40df62ec129bee4fdb5ad9706e58a29be53b2c970/aiofiles-25.1.0.tar.gz"
    sha256 "a8d728f0a29de45dc521f18f07297428d56992a742f0cd2701ba86e44d23d5b2"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "browser-cookie3" do
    url "https://files.pythonhosted.org/packages/e0/e1/652adea0ce25948e613ef78294c8ceaf4b32844aae00680d3a1712dde444/browser_cookie3-0.20.1.tar.gz"
    sha256 "6d8d0744bf42a5327c951bdbcf77741db3455b8b4e840e18bab266d598368a12"
  end

  resource "bs4" do
    url "https://files.pythonhosted.org/packages/c9/aa/4acaf814ff901145da37332e05bb510452ebed97bc9602695059dd46ef39/bs4-0.0.2.tar.gz"
    sha256 "a48685c58f50fe127722417bae83fe6badf500d54b55f7e39ffe43b798653925"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
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
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "h2" do
    url "https://files.pythonhosted.org/packages/e7/85/7c366e69d84c17bb778fe41419e1fbcce3033d5b7ce29bbffff0a98b859f/h2-4.4.1.tar.gz"
    sha256 "4e866ffb1a869ae14dd9b5e6beb5c24a13da0495ad72b65925ded182521c1516"
  end

  resource "hpack" do
    url "https://files.pythonhosted.org/packages/26/5b/fcabf6028144a8723726318b07a32c2f3314acdff6265743cf08a344b18e/hpack-4.2.0.tar.gz"
    sha256 "0895cfa3b5531fc65fe439c05eb65144f123bf7a394fcaa56aa423548d8e45c0"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "hyperframe" do
    url "https://files.pythonhosted.org/packages/02/e7/94f8232d4a74cc99514c13a9f995811485a6903d48e5d952771ef6322e30/hyperframe-6.1.0.tar.gz"
    sha256 "f630908a00854a7adeabd6382b43923a4c4cd4b821fcb527e6ab9e15382a3b08"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/16/1f/58a4d7ee466f81bc3c7337036380fc6d49de3afb7855d74f8121b1e89b32/json5-0.17.3.tar.gz"
    sha256 "8d0278ad34ebaa9c3af76d9519274811830224a2d1cd5af156dbd067f461b8a4"
  end

  resource "lz4" do
    url "https://files.pythonhosted.org/packages/57/51/f1b86d93029f418033dddf9b9f79c8d2641e7454080478ee2aab5123173e/lz4-4.4.5.tar.gz"
    sha256 "5f0b9e53c1e82e88c10d7c180069363980136b9d7a8306c4dca4f760d60c39f0"
  end

  resource "m3u8" do
    url "https://files.pythonhosted.org/packages/9b/a5/73697aaa99bb32b610adc1f11d46a0c0c370351292e9b271755084a145e6/m3u8-6.0.0.tar.gz"
    sha256 "7ade990a1667d7a653bcaf9413b16c3eb5cd618982ff46aaff57fe6d9fa9c0fd"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d9/89/5b8517baa72f84a67b8a307ba953c91057af618bf40bf676f3c03551f8f0/protobuf-7.36.2.tar.gz"
    sha256 "497d0463ff3316681da6c0b9e8d06cb465d61abce00b613ab42226175644d1bb"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/51/f2/ccbeb91d186b2323fc99986499d2da3caab2151b1c2fb2ef74f7488d8934/pycryptodome-4.4.0.tar.gz"
    sha256 "eab7620c60c85f3fa251d026ec06e094f036d96187bebb9752e46fbcebabbb55"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/f3/c2/f5855412372e47d635599a97c00cfcf9fc40accac9436a11bf9ded19f859/pycryptodomex-3.24.2.tar.gz"
    sha256 "e4dbc29e2575365d15e272f769329106277649aea081e2119cf43d66950f8f8f"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pymp4" do
    url "https://files.pythonhosted.org/packages/a5/46/dfb3f5363fc71adaf419147fdcb93341029ca638634a5cc6f7e7446416b2/pymp4-1.4.0.tar.gz"
    sha256 "bc9e77732a8a143d34c38aa862a54180716246938e4bf3e07585d19252b77bb5"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/95/48/21a393ff731b8f928fa4f8176f9a7ceba2252ee60a5149f25b45c292aa5c/soupsieve-4.1.tar.gz"
    sha256 "ca9abf7126667010d8f6e9b39bfc1bc3b23c8aed9bcb0f54a754dde969bb8aab"
  end

  # update bilibili play_info api, upstream pr ref, https://github.com/HFrost0/bilix/pull/244
  patch do
    url "https://github.com/HFrost0/bilix/commit/72c259d88b2fffb6cd530fce01b8c3d35fb79335.patch?full_index=1"
    sha256 "6f241455c6f1940626ed660d97abbcf3eecd3931cca3b6db6acd1f961649b6cb"
    type :unofficial
    resolves "https://github.com/HFrost0/bilix/pull/244"
  end

  # Fall back to the API when bilibili serves a captcha page instead of the video page
  patch do
    url "https://github.com/HFrost0/bilix/commit/f06e8aa90e88c90a38d7f2d80bad6345451525ad.patch?full_index=1"
    sha256 "540b45643af2961296bbedacde883e6df1b66a0d3b965793cd96d421a9880794"
    type :unofficial
    resolves "https://github.com/HFrost0/bilix/pull/255"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"bilix", shell_parameter_format: :click)
  end

  test do
    assert_match "day by day", shell_output("#{bin}/bilix info https://www.bilibili.com/video/av20203945/")
  end
end
