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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0f10f63f00078cdcc21abdc6ef9e5963cdccae6724c58cafc2d7058794e5c74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5351cddc0d581fb6b5eb1f60a5357c30645027a9ce039392916a179bc000473"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d6fc1241cdecb1c606233601213e9f4c60bea6c49fb0cb2c6ebe51f6bfb10a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfec889b655d961d57142f0045dc7b0bdac364c44f08a579f9b2230e318638ba"
    sha256 cellar: :any_skip_relocation, ventura:        "972eb9dbad438ca34e4ae457259a8283e1b117c915d9a2364e57368fa3eac512"
    sha256 cellar: :any_skip_relocation, monterey:       "45d3fb2225100c7925cf55e419c6abbd4636ebcb0bfe78100e9ed74f12e04842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f82f3badb58be82303489ac06d9a57b350afdf5f19a250c57c8d3ebece8044f"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "ArtifactoryDetector", shell_output("#{bin}/detect-secrets scan --list-all-plugins 2>&1")
  end
end
