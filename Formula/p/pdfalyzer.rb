class Pdfalyzer < Formula
  include Language::Python::Virtualenv

  desc "PDF analysis toolkit"
  homepage "https://github.com/michelcrypt4d4mus/pdfalyzer"
  url "https://files.pythonhosted.org/packages/d4/5b/2d87bbf1a5a81defc6ddb99ff2a5af5a2ada576de32db3b8278f54874009/pdfalyzer-1.16.1.tar.gz"
  sha256 "da776a725ad5e165922848317a3a745e10372e1a96b6eefb45883f4acdb29a0a"
  license "GPL-3.0-or-later"
  head "https://github.com/michelcrypt4d4mus/pdfalyzer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "74359e0a47ca459f2246af0cfc394136b85eeacfe75214d35c31a27f332a2fce"
    sha256 cellar: :any,                 arm64_sonoma:  "cc147583cb9801e40f2d55608fbfedac681f94eb11a505af26db9005e9a09bad"
    sha256 cellar: :any,                 arm64_ventura: "5361a33d1fe1f885075108905620352027aae864fd7b893fdc896dd9333d00ce"
    sha256 cellar: :any,                 sonoma:        "667add8cd26e9cdc19c9175f7da5c90bbf3afd4d9427882b952b020d7f7b05b5"
    sha256 cellar: :any,                 ventura:       "48efa4ee33cfe1011ad23591fbbbcb9cfbd4b94536238200bf1d97e1b7e309d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7303e0c0d12775502629ad71741439fda209dae5ea76dd85bd62cd88d97cd9e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd8f55ccc9165e438fcf522f0232091719d1dd571ebd4e3049af1d5bad718b35"
  end

  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/f9/44/2dd9c5d0c3befe899738b930aa056e003b1441bfbf34aab8fce90b2b7dea/anytree-2.12.1.tar.gz"
    sha256 "244def434ccf31b668ed282954e5d315b4e066c4940b94aff4a7962d85947830"

    # poetry build patch, upstream pr ref, https://github.com/c0fec0de/anytree/pull/271
    patch do
      url "https://github.com/c0fec0de/anytree/commit/aa20d31631403f9650f3b4090d5c8579f9abaf5b.patch?full_index=1"
      sha256 "05b9b5ecf80986fcecb195d798e1277c9e7c69ed5fd44fea9898e20a44828587"
    end
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/9d/28/6bc2ca8a521512f2904e6aa3028af43a864fe2b66c77ea01bbbc97f52b98/pypdf-5.0.1.tar.gz"
    sha256 "a361c3c372b4a659f9c8dd438d5ce29a753c79c620dc6e1fd66977651f5547ea"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f5/d7/d548e0d5a68b328a8d69af833a861be415a17cb15ce3d8f0cd850073d2e1/python-dotenv-0.21.1.tar.gz"
    sha256 "1c93de8f636cde3ce377292818d0e440b6e45a82f215c3744979151fa8151c49"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "rich-argparse-plus" do
    url "https://files.pythonhosted.org/packages/9b/34/75eaf9752783aa93498d46ccbc7046e25cc1d44e5f6c43d829d90b9dcd02/rich_argparse_plus-0.3.1.4.tar.gz"
    sha256 "aab9e49b4ba98ff501705678330eda8e9bc07d933edc5cac5f38671ee53f9998"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "yara-python" do
    url "https://files.pythonhosted.org/packages/2f/3a/0d2970e76215ab7a835ebf06ba0015f98a9d8e11b9969e60f1ca63f04ba5/yara_python-4.5.1.tar.gz"
    sha256 "52ab24422b021ae648be3de25090cbf9e6c6caa20488f498860d07f7be397930"
  end

  resource "yaralyzer" do
    url "https://files.pythonhosted.org/packages/23/73/9adfae6d87a9faaaaaccf2766e75c364314c127c81366cfecc3cce1d735d/yaralyzer-0.9.4.tar.gz"
    sha256 "a30f655e7e42221bdb069c2f4c6a8c67d10408f3d0f3e4be08dab7dbf0ffe6ba"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfalyze --version")

    resource "homebrew-test-pdf" do
      url "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
      sha256 "3df79d34abbca99308e79cb94461c1893582604d68329a41fd4bec1885e6adb4"
    end

    resource("homebrew-test-pdf").stage testpath

    output = shell_output("#{bin}/pdfalyze dummy.pdf")
    assert_match "'/Producer': 'OpenOffice.org 2.1'", output
  end
end
