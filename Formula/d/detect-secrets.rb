class DetectSecrets < Formula
  include Language::Python::Virtualenv

  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https://github.com/Yelp/detect-secrets"
  url "https://files.pythonhosted.org/packages/f1/55/292f9ce52bba7f3df0a9cde65dabf458d3aeec6a63bf737e5a5fa9fe6d31/detect_secrets-1.4.0.tar.gz"
  sha256 "d56787e339758cef48c9ccd6692f7a094b9963c979c9813580b0169e41132833"
  license "Apache-2.0"
  revision 4
  head "https://github.com/Yelp/detect-secrets.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "700c31972728f1f171a8832b367d04a7d82a33addf0598b6c959f6d528d1c2f4"
    sha256 cellar: :any,                 arm64_ventura:  "f134b43523193c1400d96e922c28deeb69b5157b3966b54f7225cc0b8d1033fe"
    sha256 cellar: :any,                 arm64_monterey: "2d6125cd7d98bd7203caf8ba16bd22bc1c04ec60dec01247130a11465700760d"
    sha256 cellar: :any,                 sonoma:         "8cccf3956a0063f7ab351c71ce5e4bab6b88346f59fd58fc4be432cbee6b5fb4"
    sha256 cellar: :any,                 ventura:        "e4752c09b691d41004bae467999bf5b45f9f09b727a93d09f2734e7ff664599e"
    sha256 cellar: :any,                 monterey:       "8f408a18ffc6febe9c2cb368d687b109dd0575598fb59c827648dfdbc247448c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bb1f2d9166832277d86d879ebecd0742c45112520a3431c950c7b4af5554b1c"
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
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
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
