class Beancount < Formula
  include Language::Python::Virtualenv

  desc "Double-entry accounting tool that works on plain text files"
  homepage "https://beancount.github.io/"
  url "https://files.pythonhosted.org/packages/f6/b1/2587862caf3367f2d421be9da278f547296b00b7f9610ca9a94fddd8c709/beancount-2.3.6.tar.gz"
  sha256 "801f93bed6b57d2e22436688c489d5a1bf1f76e210f3ced18680757e60d3475a"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/beancount/beancount.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6bf46d7305968a592a2a54ca8b76b410b14927c8f5833d8c0c5f2130e69a559"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "beb3260d20ee5cbee13ba67370dd0d1283b291b6ea00a34f1a45c0aea05ad8f2"
    sha256 cellar: :any,                 arm64_monterey: "a1dd49da1fd209471f13b9ebd499d0e2c110ea43aafad6b82775eeab2bf58c0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4aa0789f35c91ea56506a1fda2f02ed2f0408b2e34bcb6a2ebfdc21f60d882ce"
    sha256 cellar: :any_skip_relocation, ventura:        "b0954be3abb39d7806255572c03298aeb208f928c05f1f51bbce2b46f3706837"
    sha256 cellar: :any,                 monterey:       "502cd6990d0d462798077fe4d2f58a95cecea6b3784a077bafb5f341fbef6536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8d766ec34d7ec9ce04b0631b4f3f1d7321c60dce45f58e184baeb2e6b7abf24"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/fd/04/1c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215/bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/b3/4d/27a3e6dd09011649ad5210bdf963765bc8fa81a0827a4fc01bafd2705c5b/cachetools-5.3.3.tar.gz"
    sha256 "ba29e2dfa0b8b556606f097407ed1aa62080ee108ab0dc5ec9d6a723a007d105"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/b2/8f/ecd68579bd2bf5e9321df60dcdee6e575adf77fedacb1d8378760b2b16b6/google-api-core-2.18.0.tar.gz"
    sha256 "62d97417bfc674d6cef251e5c4d639a9655e00c45528c4364fbfebb478ce72a9"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/ac/7a/5b7b208a29c278128a9c27470338960a050da1fc74d18e10525a12fae4fc/google-api-python-client-2.125.0.tar.gz"
    sha256 "51a0385cff65ec135106e8be60ee7112557396dde5f44113ae23912baddda143"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/18/b2/f14129111cfd61793609643a07ecb03651a71dd65c6974f63b0310ff4b45/google-auth-2.29.0.tar.gz"
    sha256 "672dff332d073227550ffc7457868ac4218d6c500b155fe6cc17d2b13602c360"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/d2/dc/291cebf3c73e108ef8210f19cb83d671691354f4f7dd956445560d778715/googleapis-common-protos-1.63.0.tar.gz"
    sha256 "17ad01b11d5f1d0171c06d3ba5c04c54474e883b66b949722b4938ee2694ef4e"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ea/e2/3834472e7f18801e67a3cd6f3c203a5456d6f7f903cfb9a990e62098a2f3/lxml-5.2.1.tar.gz"
    sha256 "3f7765e69bbce0906a7c74d5fe46d2c7a7596147318dbc08e4a2431f3060e306"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pdfminer2" do
    url "https://files.pythonhosted.org/packages/55/18/0a856200ff54db80612f66878f9b037ddb9c873f885bc58339b528611994/pdfminer2-20151206.tar.gz"
    sha256 "7d05aa3dd1e779080fef13aef454501b51a3f7649d7f18e78c640bdbd34e1e77"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/54/c6/43f9d44d92aed815e781ca25ba8c174257e27253a94630d21be8725a2b59/pluggy-1.4.0.tar.gz"
    sha256 "8c85c2876142a764e5b7548e7d9a0e0ddb46f5185161049a79b7e974454223be"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/91/2d/8c7fa3011928b024b10b80878160bf4e374eccb822a5d090f3ebcf175f6a/proto-plus-1.23.0.tar.gz"
    sha256 "89075171ef11988b3fa157f5dbd8b9cf09d65fffee97e29ce403cd8defba19d2"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/5e/d8/65adb47d921ce828ba319d6587aa8758da022de509c3862a70177a958844/protobuf-4.25.3.tar.gz"
    sha256 "25b5d0b42fd000320bd7830b349e3b696435f3b329810427a6bcce6a5492cc5c"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/4a/a3/d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0d/pyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/f7/00/e7bd1dec10667e3f2be602686537969a7ac92b0a7c5165be2e5875dc3971/pyasn1_modules-0.4.0.tar.gz"
    sha256 "831dbcea1b177b28c9baddf4c6d1013c24c3accd14a1873fffaa6a2e905f17b6"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/46/3a/31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842/pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/30/b7/7d44bbc04c531dcc753056920e0988032e5871ac674b5a84cb979de6e7af/pytest-8.1.1.tar.gz"
    sha256 "ac978141a75948948817d360297b7aae0fcb9d6ff6bc9ec6d514b85d5a65c044"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.ledger").write shell_output("#{bin}/bean-example").strip
    assert_equal "", shell_output("#{bin}/bean-check #{testpath}/example.ledger").strip
  end
end
