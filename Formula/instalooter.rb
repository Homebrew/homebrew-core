class Instalooter < Formula
  include Language::Python::Virtualenv

  desc "Download any picture or video associated from an Instagram profile"
  homepage "https://github.com/althonos/instalooter"
  url "https://files.pythonhosted.org/packages/30/13/907e6aaba6280e1001080ab47e750068ffc5fb7174203985b3c9d678e3f2/instalooter-2.4.4.tar.gz"
  sha256 "fb9b4a948702361a161cc42e58857e3a6c9dafd9e22568b07bc0d0b09c3c34a9"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cad091558eb5bd1495501dbe9fb6669b5a3088cf9f20f6e442495b9b7aeace6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c8b6da2922c02e21f0613254e52e13d404bcc0c093244d25129bb38bc5a2be7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35873f81fdf70dcf619ce044f18ef7ae6a48d8817fe642267f8da6a22d0a0f87"
    sha256 cellar: :any_skip_relocation, ventura:        "b6609bcc7bcc08a5962bfd8809ed70cb431580869d4c137ec62d996a4d6cb6d8"
    sha256 cellar: :any_skip_relocation, monterey:       "7b400055f5c71f707e93959e80f215de2b90fc4ea342b705579c7ddffa30a7f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d75ca6a5dd22ae2e15554c99d1a55d54774530ebf10d4c8cf872c1170465c0e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdeed01b88f0a29560bcc057bc8efa93961b9a15c83077d4e10e7d6345294fd9"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
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
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/70/0c/47136795c8be87c7c30f28c9a56b59deb9550b2a1f5f3abb177daf5da1a3/tenacity-6.3.1.tar.gz"
    sha256 "e14d191fb0a309b563904bbc336582efe2037de437e543b38da749769b544d7f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/c1/c2/d8a40e5363fb01806870e444fc1d066282743292ff32a9da54af51ce36a2/tqdm-4.64.1.tar.gz"
    sha256 "5f4f682a004951c1b450bc753c710e9280c5746ce6ffedee253ddbcbf54cf1e4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
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
