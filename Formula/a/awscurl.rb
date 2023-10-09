class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https://github.com/okigan/awscurl"
  url "https://files.pythonhosted.org/packages/80/f4/95935ad7041ba008221ce81b698963c8be0c5c97e6fcfd86e0e2009ebacd/awscurl-0.29.tar.gz"
  sha256 "5e1ecd0ab7b014de697a1e161fa483c2263d16c3e156a81bdc8b9a9c2d0ba3f3"
  license "MIT"
  revision 5
  head "https://github.com/okigan/awscurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8208f9986bc549def633ccbdd508a2b8c7896ab6c43f699a71df7b6ac8b9743"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1acb92ae8cf43bc0e18c3f686516fd18b6329758d360cfa5f7383027fdb99484"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac1d9cfeb64bb41802001dcccb9bbf5fa2eb3151532bdab13be79175be34a824"
    sha256 cellar: :any_skip_relocation, sonoma:         "329ee56b64364dae0995986c8a33566d5f13e25beb7fc2a7b55258f4dd2dedb4"
    sha256 cellar: :any_skip_relocation, ventura:        "818fff63a8836eba670acc97204972dfdaa887d065c3124571a77bcbb1fa59d9"
    sha256 cellar: :any_skip_relocation, monterey:       "4fa1266e18b2b370097d6327a9fe58866e8687300e3dced4f01cdfe12494d33b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d671d041c642c25fb08ae441d92cecb05548c7eaded826fe4155b373e2314a26"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.11"

  uses_from_macos "libffi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/0b/65/bad3eb64f30657ee9fa2e00e80b3ad42037db5eb534fadd15a94a11fe979/configparser-6.0.0.tar.gz"
    sha256 "ec914ab1e56c672de1f5c3483964e68f71b34e457904b7b76e06b922aec067a8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/be/df/75a6525d8988a89aed2393347e9db27a56cb38a3e864314fac223e905aef/pyOpenSSL-23.2.0.tar.gz"
    sha256 "276f931f55a452e7dea69c7173e984eb2a4407ce413c918aa34b55f82f9b8bac"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  resource "urllib3-secure-extra" do
    url "https://files.pythonhosted.org/packages/c9/67/76b7c055ea787729bb9f839a84689ea2f88e217519d59ae547824431ec95/urllib3-secure-extra-0.1.0.tar.gz"
    sha256 "ee9409cbfeb4b8609047be4c32fb4317870c602767e53fd8a41005ebe6a41dff"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Curl", shell_output("#{bin}/awscurl --help")

    assert_match "No access key is available",
      shell_output("#{bin}/awscurl --service s3 https://homebrew-test-non-existent-bucket.s3.amazonaws.com 2>&1", 1)
  end
end
