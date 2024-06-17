class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host"
  homepage "https://github.com/10gen/mongo-orchestration"
  url "https://files.pythonhosted.org/packages/80/bc/46ec328dcb9abcc8e9956c02378bfd4bfb053cb94fcf40b62b75f900d147/mongo-orchestration-0.8.0.tar.gz"
  sha256 "9cb17a4f1a19d578a04c34ef51f4d5bc2a1c768f4968948792f330644c9398f6"
  license "Apache-2.0"
  revision 5
  head "https://github.com/10gen/mongo-orchestration.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a3f43767c123f3233a34850e09f1f41dec8c1a292dc5896a1bf6e049f82a133"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bde4b5e7f294bf976728640790e9eeb757a36e60eb9c6dc82a7d82cb8bdd7c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07b4a108f9b541c52a927504a6da0771b6984481b1f81cc02fbc8c5f2d58ddc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "5cbe53641f551ffa790713711f3f8d814e775acdf4688a6c655e9bf7f673d24f"
    sha256 cellar: :any_skip_relocation, ventura:        "9890b079b29b0662b777f94dd069afa1c8bc878181156413fc0f6238541ea923"
    sha256 cellar: :any_skip_relocation, monterey:       "1f85ebb0e06ba655ac4d89bc0c9f26afed75adb1a276a08766f7bb79c6d40a76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a30eb4de90902ce3a95ded535ecea7befcc5352e82691835ea92901011cc061"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/fd/04/1c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215/bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/63/e2/f85981a51281bd30525bf664309332faa7c81782bb49e331af603421dbd1/cheroot-10.0.1.tar.gz"
    sha256 "e0b82f797658d26b8613ec8eb563c3b08e6bd6a7921e9d5089bd1175ad1b1740"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/37/7d/c871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939/dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/bc/66/746091bed45b3683d1026cb13b8b7719e11ccc9857b18d29177a18838dc9/jaraco_functools-4.0.1.tar.gz"
    sha256 "d33fa765374c0611b52f8b3a795f8900869aa88c84769d4d1746cd68fb28c3e8"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/df/ad/7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4/more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "pymongo" do
    url "https://files.pythonhosted.org/packages/af/7a/3401c2f16bff666e7b2d0416a345e2cb4059d27c98cb80aad66cb82dda69/pymongo-4.7.2.tar.gz"
    sha256 "9024e1661c6e40acf468177bf90ce924d1bc681d2b244adda3ed7b2f4c4d17d7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/86/ec/535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392db/requests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin/"mongo-orchestration", "-b", "127.0.0.1", "-p", "8889", "--no-fork", "start"]
    require_root true
  end

  test do
    system "#{bin}/mongo-orchestration", "-h"
  end
end
