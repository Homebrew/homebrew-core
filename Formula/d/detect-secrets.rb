class DetectSecrets < Formula
  include Language::Python::Virtualenv

  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https://github.com/Yelp/detect-secrets"
  url "https://files.pythonhosted.org/packages/f1/55/292f9ce52bba7f3df0a9cde65dabf458d3aeec6a63bf737e5a5fa9fe6d31/detect_secrets-1.4.0.tar.gz"
  sha256 "d56787e339758cef48c9ccd6692f7a094b9963c979c9813580b0169e41132833"
  license "Apache-2.0"
  revision 3
  head "https://github.com/Yelp/detect-secrets.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "369d04afa889d5ee9635f530ab53b2df4ed7634d529f16948a29ef5909829857"
    sha256 cellar: :any,                 arm64_ventura:  "8a88936d5203a614ad21522ef4389611c76883d9f415a80b9e96a6f4ac109359"
    sha256 cellar: :any,                 arm64_monterey: "86c9210007811b70e213339122faad329d6612da0e8dfef8bac3bfa76039ef90"
    sha256 cellar: :any,                 sonoma:         "b0c76a50fb08fbe80f13e080b5822ac4e68d2b97c7bdd647b3ebbba2ddc0cb7b"
    sha256 cellar: :any,                 ventura:        "a887cfa36f12e3af499e4bd071852a15ad2d95357d58987242445d992e1caeed"
    sha256 cellar: :any,                 monterey:       "0f48a9fa4d37049ceab4d716b9e40d6e990949d97ac245ec1ee30d2ec9e68409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08510131dace027059a68516b5b41620f0cee95954dd93d50fd6cbdd41eac8fc"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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
