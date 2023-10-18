class Instalooter < Formula
  include Language::Python::Virtualenv

  desc "Download any picture or video associated from an Instagram profile"
  homepage "https://github.com/althonos/instalooter"
  url "https://files.pythonhosted.org/packages/30/13/907e6aaba6280e1001080ab47e750068ffc5fb7174203985b3c9d678e3f2/instalooter-2.4.4.tar.gz"
  sha256 "fb9b4a948702361a161cc42e58857e3a6c9dafd9e22568b07bc0d0b09c3c34a9"
  license "GPL-3.0-or-later"
  revision 5

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b669faeba478d6c31af90394a35bf2393f3a0edf7ff7855dc3ef46746c82d32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd7a038d406fbf23981f04ccf031315f7ab6ba857ba6234e0f2afad883fb7642"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "424cef7f2e7602d87fe440e05822806454156ff1465b48e78f2c6dfb78eb3442"
    sha256 cellar: :any_skip_relocation, sonoma:         "269fbc3c64dbbef30717e4ef596c73f89e4b2e981dc5edda6f039baeda62e5ed"
    sha256 cellar: :any_skip_relocation, ventura:        "d7e0b6127617a97ba3d1eed4892f4e23532c9356b370f0086016b123b0982db4"
    sha256 cellar: :any_skip_relocation, monterey:       "c3add62931d5965f2864adc7dfee8af04ab4b9b6470b052f960aaf7417d73355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3a697e66b9e0ac8ba5471dffee54f965b602c945e5c1532c861c90a049bb5ba"
  end

  depends_on "python-certifi"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/5a/6d/1796dc260bfd8be7c9ecd9c17e02b5b2ad9ba310983cc4ceabc1ea4dbb42/coloredlogs-14.3.tar.gz"
    sha256 "7ef1a7219870c7f02c218a2f2877ce68f2f8e087bb3a55bd6fbaa2a4362b4d52"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "fs" do
    url "https://files.pythonhosted.org/packages/5d/a9/af5bfd5a92592c16cdae5c04f68187a309be8a146b528eac3c6e30edbad2/fs-2.4.16.tar.gz"
    sha256 "ae97c7d51213f4b70b6a958292530289090de3a7e15841e108fbe144f069d313"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/70/0c/47136795c8be87c7c30f28c9a56b59deb9550b2a1f5f3abb177daf5da1a3/tenacity-6.3.1.tar.gz"
    sha256 "e14d191fb0a309b563904bbc336582efe2037de437e543b38da749769b544d7f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  resource "verboselogs" do
    url "https://files.pythonhosted.org/packages/29/15/90ffe9bdfdd1e102bc6c21b1eea755d34e69772074b6e706cab741b9b698/verboselogs-1.7.tar.gz"
    sha256 "e33ddedcdfdafcb3a174701150430b11b46ceb64c2a9a26198c76a156568e427"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"instalooter", "logout"
  end
end
