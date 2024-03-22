class BandcampDl < Formula
  include Language::Python::Virtualenv

  desc "Simple python script to download Bandcamp albums"
  homepage "https://github.com/iheanyi/bandcamp-dl"
  url "https://files.pythonhosted.org/packages/e5/4d/d463bcc20602f5385e0441cd7171b1fe6b67e2bb76240ae0f2684de6c022/bandcamp-downloader-0.0.15.tar.gz"
  sha256 "2f7666c00e9cff39135d5c9fc0498bbc93d64684fcb13171cbd9584e31692ebb"
  license "Unlicense"
  revision 1
  head "https://github.com/iheanyi/bandcamp-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c6d1cf24d4ee1f1c5106eba30dbb53380b7748861a5d9b41a6819ce1c5eb503"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "971162229362dd25a6f1fa06d51138be507d72b4fedfc956ef88d07b7d777ba8"
    sha256 cellar: :any,                 arm64_monterey: "ff33514eb86e07ed9296e616c5a665ed9bbecb6dd1d3c068f3774c46af0c3092"
    sha256 cellar: :any_skip_relocation, sonoma:         "371ff3df01cfadcd1ffb4501454cbc9af971854226cb36d51bf6129026ee3a95"
    sha256 cellar: :any_skip_relocation, ventura:        "9184b0aa6ba5ee8b89c03a756e22a0a8029f37c8fa3421379c0dcc6a56334fb8"
    sha256 cellar: :any,                 monterey:       "4f3001a6b9f7e9b557b9f3222995435dce2fda17a817210dff7fa34bfd442d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c5bf42d56da20b6a677d5ebf42d03696641dcff32f6a44085019931f6794814"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/75/f8/de84282681c5a8307f3fff67b64641627b2652752d49d9222b77400d02b8/beautifulsoup4-4.11.2.tar.gz"
    sha256 "bc4bdda6717de5a2987436fb8d72f45dc90dd856bdfd512a1314ce90349a0106"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/41/32/cdc91dcf83849c7385bf8e2a5693d87376536ed000807fa07f5eab33430d/chardet-5.1.0.tar.gz"
    sha256 "0d62712b956bc154f85fb0a266e2a3c5913c2967e00348701b32411d6def31e5"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "demjson3" do
    url "https://files.pythonhosted.org/packages/f7/d2/6a81a9b5311d50542e11218b470dafd8adbaf1b3e51fc1fddd8a57eed691/demjson3-3.0.6.tar.gz"
    sha256 "37c83b0c6eb08d25defc88df0a2a4875d58a7809a9650bd6eee7afd8053cdbac"
  end

  resource "docopt-ng" do
    url "https://files.pythonhosted.org/packages/06/4c/91ac57392aae9e44cc159f1e41859b8c9c546ef0ecb94aaee126c3854d73/docopt-ng-0.8.1.tar.gz"
    sha256 "ea6a61a288fc864eee6b22d6fe28aa202d59fc86fad05f16ff5e39cc4ea7f6e3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/2b/b4/bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845/lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/b1/54/d1760a363d0fe345528e37782f6c18123b0e99e8ea755022fd51f1ecd0f9/mutagen-1.46.0.tar.gz"
    sha256 "6e5f8ba84836b99fe60be5fb27f84be4ad919bbb6b49caa6ae81e70584b55e58"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "unicode-slugify" do
    url "https://files.pythonhosted.org/packages/ed/37/c82a28893c7bfd881c011cbebf777d2a61f129409d83775f835f70e02c20/unicode-slugify-0.1.5.tar.gz"
    sha256 "25f424258317e4cb41093e2953374b3af1f23097297664731cdb3ae46f6bd6c3"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/f7/89/19151076a006b9ac0dd37b1354e031f5297891ee507eb624755e58e10d3e/Unidecode-1.3.8.tar.gz"
    sha256 "cfdb349d46ed3873ece4586b96aa75258726e2fa8ec21d6f00a591d98806c2f4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"bandcamp-dl", "--artist=iamsleepless", "--album=rivulets"
    assert_predicate testpath/"iamsleepless/rivulets/01 - rivulets.mp3", :exist?
    system bin/"bandcamp-dl", "https://iamsleepless.bandcamp.com/track/under-the-glass-dome"
    assert_predicate testpath/"iamsleepless/under-the-glass-dome/Single - under-the-glass-dome.mp3", :exist?
  end
end
