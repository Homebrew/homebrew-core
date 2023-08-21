class DetectSecrets < Formula
  include Language::Python::Virtualenv

  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https://github.com/Yelp/detect-secrets"
  url "https://files.pythonhosted.org/packages/f1/55/292f9ce52bba7f3df0a9cde65dabf458d3aeec6a63bf737e5a5fa9fe6d31/detect_secrets-1.4.0.tar.gz"
  sha256 "d56787e339758cef48c9ccd6692f7a094b9963c979c9813580b0169e41132833"
  license "Apache-2.0"
  revision 1
  head "https://github.com/Yelp/detect-secrets.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7d406f96b55d25c172002af752f055d8b16cb941c1c8f71b1f109c34f01618f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a360bf8ffe9ddf0fc025431061a6f155dfb65e2f59febc53f55316ede82eb801"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f631142f552c0d1a03258b135963a753cbff2297602384142b2f8cc886deec5b"
    sha256 cellar: :any_skip_relocation, ventura:        "3f51a6d84d1c69b8121340b12648e71c900a8c073f027caac8e4eba0e7935792"
    sha256 cellar: :any_skip_relocation, monterey:       "1dabc85eca7b07da8551ffd5951ddeffe52c20772e626e184fe5273c411984c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3165fd88b2217ed08c8cb860ab03f9f45c84c8b756867a2f83f0c8f9d8c6b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42a0f337444e9930d38bc5e8df2eb26fbe3c9f8952c842f153cdbce5aab55adc"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "ArtifactoryDetector", shell_output("#{bin}/detect-secrets scan --list-all-plugins 2>&1")
  end
end
