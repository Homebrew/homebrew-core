class Instaloader < Formula
  include Language::Python::Virtualenv

  desc "Download media from Instagram"
  homepage "https://instaloader.github.io/"
  url "https://files.pythonhosted.org/packages/7e/35/1f8d36c0656d4797fc5089c016995447f2b439e8fb9df02bf9d7873566fc/instaloader-4.11.tar.gz"
  sha256 "7478a1f0ed5c05911832c50cb19747243a461b5d434907f9fdb7d2d750d1b4f5"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "942757bf0e1d09121405f03026e6902191c0aad8b6a27a40675b6857a2e2568c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d71516e5024696fb3ec578642bc48cc88d880926ad57efdc12078a99791f73e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02b6275cbcb268a54e282ba8d68e033a4898fb12dc10d0a8c0e73e98007c65ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "18df021f306422cc5bd1b63c292fafd99ea3c652a9ef6f967abad6857ea76db6"
    sha256 cellar: :any_skip_relocation, ventura:        "be4e6bd89bb03cf62767fe419b49d05de42d2fbf448cecc1e91f76df6c7a30db"
    sha256 cellar: :any_skip_relocation, monterey:       "9943504924ec77e7f3d559758f2e6c21ae42f9c142b06857d1172326f839dd21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0be398a0ea7789f5e3b8d79a30845418062c1b05d22f6867913fb8c037a2b14c"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
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

  test do
    output = shell_output("#{bin}/instaloader --login foo --password bar 2>&1", 1)
    assert_match "Fatal error: Login error:", output

    assert_match version.to_s, shell_output("#{bin}/instaloader --version")
  end
end
