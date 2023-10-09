class AdbEnhanced < Formula
  include Language::Python::Virtualenv

  desc "Swiss-army knife for Android testing and development"
  homepage "https://ashishb.net/tech/introducing-adb-enhanced-a-swiss-army-knife-for-android-development/"
  url "https://files.pythonhosted.org/packages/82/11/1228620ea0c9204d6d908d8485005141ab3d71d3db71a152080439fa927d/adb-enhanced-2.5.22.tar.gz"
  sha256 "b829dcb4c9a9422735d416a62820de679bed8b08dfbff2014d46a525c39bc7d0"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d22bc650c9d2bffe7d4b908d1a81e78e3426480f9bc1202a68fb5441eae9586"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c5da01990bdc3719a2cdcdaba47f517d1866887adf2085c7f5d25aa2f0eee12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c220eaac79ddf634fa3260cd5f28a04ad91fe806c016c830b25d3bd99c73da0"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c9144b5b3ff56d0cf41820f7dca289d8ad9a3dd118c5e84435ed4469b0d778d"
    sha256 cellar: :any_skip_relocation, ventura:        "87866c1be5807f3cdb8c230917f68c4d6956b88eb42663544d3809e1e3d51674"
    sha256 cellar: :any_skip_relocation, monterey:       "3f9df1b6cac3096b9fc9e5f11bbb62baa1206d52777e4182ff5bdd4ba86c284f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "941de410df686f9a6621583202e012e5ce0f28de0fa4999192887acc67ab6ef1"
  end

  depends_on "python@3.12"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/adbe --version")
    # ADB is not intentionally supplied
    # There are multiple ways to install it and we don't want dictate
    # one particular way to the end user
    assert_match(/(not found)|(No attached Android device found)/, shell_output("#{bin}/adbe devices", 1))
  end
end
