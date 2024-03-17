class Arjun < Formula
  include Language::Python::Virtualenv

  desc "HTTP parameter discovery suite"
  homepage "https://github.com/s0md3v/Arjun"
  url "https://files.pythonhosted.org/packages/2a/f9/ac1bb63ab98f637239c665c33d39d1425bcc18ac2b2df2d079a54a74ce81/arjun-2.2.4.tar.gz"
  sha256 "8e4baefaaf736d4e1bd51e40ad764118261aeac73aa820d3149a472a06080fcb"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e14cd0cdd03be123f2e94104833f4cae88a040cc0d173230283f360a01925b16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89615d66134221dc0473829040456ce11d9eb1df511ee4bd8a7e12dd05c04959"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f3d70502273ad63723fc7d8ffca102969f96342110fea0a8268fddab7426cec"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9032ec3eb5e6aa9a949a975c07dcef3a39ee3b4b362d211e0abe3de0c446895"
    sha256 cellar: :any_skip_relocation, ventura:        "5e886e2371316598924249efeefb0d479df3afcb0fea07c7661b3b22dbc7c125"
    sha256 cellar: :any_skip_relocation, monterey:       "715a17ea8dea4f3fb9002178e05b88868ffa457402c82a4681d06265b6bd40b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ceede517c5682d225bdb12f54291054bc36be1f16a10c82f90a7d4aa868b463"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dicttoxml" do
    url "https://files.pythonhosted.org/packages/ee/c9/3132427f9e64d572688e6a1cbe3d542d1a03f676b81fb600f3d1fd7d2ec5/dicttoxml-1.7.16.tar.gz"
    sha256 "6f36ce644881db5cd8940bee9b7cb3f3f6b7b327ba8a67d83d3e2caa0538bf9d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "ratelimit" do
    url "https://files.pythonhosted.org/packages/ab/38/ff60c8fc9e002d50d48822cc5095deb8ebbc5f91a6b8fdd9731c87a147c9/ratelimit-2.2.1.tar.gz"
    sha256 "af8a9b64b821529aca09ebaf6d8d279100d766f19e90b5059ac6a718ca6dee42"
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
    output = shell_output("#{bin}/arjun -u https://mockbin.org/ -m GET")
    assert_match "No parameters were discovered", output
  end
end
