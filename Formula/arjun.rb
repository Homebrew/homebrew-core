class Arjun < Formula
  include Language::Python::Virtualenv

  desc "HTTP parameter discovery suite"
  homepage "https://github.com/s0md3v/Arjun"
  url "https://files.pythonhosted.org/packages/51/cd/8eaadf3973a4e7bb519b885588b13348ddbe6d97ca06ecdcdda5f7a53dcb/arjun-2.2.1.tar.gz"
  sha256 "b1904add44c0c5a8241910b0555d7e252281187b7dadd16ebc0843dc768cb36e"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7667ac67324890ba1890389da777cbb8dcfbc8f913e4f9e301d83e971a286107"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a740518be5daed73f06bdcdd0be05a1b74b37f4067fac39023ad818b1bc3b1bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baa1ea7fcbca8f461d9ccee7cfc034226cf469a3f37fcd9524a258bdd0b7b7d8"
    sha256 cellar: :any_skip_relocation, ventura:        "2aa89db17844cbb201d464fb3f800c467840e3dd1a84d82f0b9c20fa1612c5c1"
    sha256 cellar: :any_skip_relocation, monterey:       "7df9147055649551278691737890604a2aff6d13b14341e8ae78987ba49b485c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ec3d459c87cc55da1fbc882975c9acd316ca3adc3cb9c97e6589a2f18890b71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39d379ac7295e72e949c95c4a2295cf3f81751a5cecca50574905699c71b9517"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "dicttoxml" do
    url "https://files.pythonhosted.org/packages/ee/c9/3132427f9e64d572688e6a1cbe3d542d1a03f676b81fb600f3d1fd7d2ec5/dicttoxml-1.7.16.tar.gz"
    sha256 "6f36ce644881db5cd8940bee9b7cb3f3f6b7b327ba8a67d83d3e2caa0538bf9d"
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
    output = shell_output("#{bin}/arjun -u https://mockbin.org/ -m GET")
    assert_match "No parameters were discovered", output
  end
end
