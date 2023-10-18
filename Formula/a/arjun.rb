class Arjun < Formula
  include Language::Python::Virtualenv

  desc "HTTP parameter discovery suite"
  homepage "https://github.com/s0md3v/Arjun"
  url "https://files.pythonhosted.org/packages/51/cd/8eaadf3973a4e7bb519b885588b13348ddbe6d97ca06ecdcdda5f7a53dcb/arjun-2.2.1.tar.gz"
  sha256 "b1904add44c0c5a8241910b0555d7e252281187b7dadd16ebc0843dc768cb36e"
  license "AGPL-3.0-only"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb788dc5db6eeffe1017b76e545ab7496eb864ea494d6cee5a340e88ddb54347"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d16e4bd910501c8cdea6ab3c627d9bda3818ec321153608d248ad93e6788edf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "237ff6e8dec46ba50de22927fc469fbb1dc53a0b446c3b964ca57f56b74f6eae"
    sha256 cellar: :any_skip_relocation, sonoma:         "972ae08a334985cfe0dc5e63e2ad185bc638d2b1bc989ac73d97e79a73e921b8"
    sha256 cellar: :any_skip_relocation, ventura:        "2bf2d8dc1da010b4c39ad698a5706f91e48b2847eb825c25100ce483edccacee"
    sha256 cellar: :any_skip_relocation, monterey:       "24c39bdd2fe7e1e9c39f8fbb07437b25f37e7bc188c210cd1be32133ee504979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06fdfa646ed1c5c10047db402bca1c89cc281a08c7a28b96514438688db55fd1"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/arjun -u https://mockbin.org/ -m GET")
    assert_match "No parameters were discovered", output
  end
end
