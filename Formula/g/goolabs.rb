class Goolabs < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for morphologically analyzing Japanese language"
  homepage "https://pypi.python.org/pypi/goolabs"
  url "https://files.pythonhosted.org/packages/ce/86/2d3b5bd85311ee3a7ae7a661b3619095431503cd0cae03048c646b700cad/goolabs-0.4.0.tar.gz"
  sha256 "4f768a5b98960c507f5ba4e1ca14d45e3139388669148a2750d415c312281527"
  license "MIT"
  revision 7

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bd701a453f954a13658ad92f71e5c14e226c9fe6a92727c7c7ccb5f15c907a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9e7d7e87de181ced8471bbfce522b655d999f8241c21fbc4005ff91c17ee6d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13447039d6faf4f55782dd9540a2e4de141d79997b58f0546ff2571b63542166"
    sha256 cellar: :any_skip_relocation, sonoma:         "c36c85d100f4de6f3ac9cc96a33fce4fd723b87422ff22a18430de66f05f583f"
    sha256 cellar: :any_skip_relocation, ventura:        "6c20f42708141d1426daa0ef8c4580d270200381c26b07d5eee8ec90b5746a44"
    sha256 cellar: :any_skip_relocation, monterey:       "c15d278d0ea075dbeef84aa9adbaf3dbc93b787f96b8c6b7048d861caf409008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f6283db4d6f018fb30022d0bd73c181bc32b98ea27ef9b4d63cde8d42b72620"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python@3.12"
  depends_on "six"

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
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage: goolabs morph", shell_output("#{bin}/goolabs morph test 2>&1", 2)
  end
end
