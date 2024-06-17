class DetectSecrets < Formula
  include Language::Python::Virtualenv

  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https://github.com/Yelp/detect-secrets"
  url "https://files.pythonhosted.org/packages/69/67/382a863fff94eae5a0cf05542179169a1c49a4c8784a9480621e2066ca7d/detect_secrets-1.5.0.tar.gz"
  sha256 "6bb46dcc553c10df51475641bb30fd69d25645cc12339e46c824c1e0c388898a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/Yelp/detect-secrets.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "32016e9cd914c77dca20151657b49a99b659039dd994adde46099addbe507a24"
    sha256 cellar: :any,                 arm64_ventura:  "01aa11cd4ea2c96fdf106cb0c1077814049e594b52977b70d1d11f91fa22c56b"
    sha256 cellar: :any,                 arm64_monterey: "44ec738cdc3f03bf96042df56161e92754b88b8f0f931f45ad33c75d40df07aa"
    sha256 cellar: :any,                 sonoma:         "d70372d7051ce239332c75d78566901b1d7d12dafafff0da9c408fa01a2c5b67"
    sha256 cellar: :any,                 ventura:        "18e0a50762143176fd5cfb720376f053e42f476783d9b580da4f180c8d09cee3"
    sha256 cellar: :any,                 monterey:       "5f3e380bf40ba837d812eec0be395c1a3aa1530f9717ca38dc794fe7cf82d462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7d983dd78ee130861ae918b2c30b8bd50ef99f999448ee7274a9478f6935339"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/d8/c1/f32fb7c02e7620928ef14756ff4840cae3b8ef1d62f7e596bc5413300a16/requests-2.32.1.tar.gz"
    sha256 "eb97e87e64c79e64e5b8ac75cee9dd1f97f49e289b083ee6be96268930725685"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "ArtifactoryDetector", shell_output("#{bin}/detect-secrets scan --list-all-plugins 2>&1")
  end
end
