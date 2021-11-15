class Instalooter < Formula
  include Language::Python::Virtualenv

  desc "Download any picture or video associated from an Instagram profile"
  homepage "https://github.com/althonos/instalooter"
  url "https://files.pythonhosted.org/packages/30/13/907e6aaba6280e1001080ab47e750068ffc5fb7174203985b3c9d678e3f2/instalooter-2.4.4.tar.gz"
  sha256 "fb9b4a948702361a161cc42e58857e3a6c9dafd9e22568b07bc0d0b09c3c34a9"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d29da3eb63c5d5115e8f39438c978469c047d4e59b1ce82a653e6ea21f21a9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20316dff8da3999d6aa335e8e9d6555e1bdb4f9237421692c67944828ca1e60d"
    sha256 cellar: :any_skip_relocation, monterey:       "157d6e8976b14205641a072423e26ad69d15603b0ba899b6a786a71cf317e5d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "da5e277f2cd0dbdef07b853b1952de7798195760885dc39185ba20783109a5e3"
    sha256 cellar: :any_skip_relocation, catalina:       "0f5793e71d06911c8345f2a8e4cb6c47ad92100695862f1e0cf7c0bbc16be5da"
    sha256 cellar: :any_skip_relocation, mojave:         "76edccfab0fe943afd0754e2bb142fb6eec24462718efc49d915b3f0517058bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79d3ab0b25f10c67dbdb77dbd17ffe85fbbdb1a2eeccab0e6ffe6468ee5eeb02"
  end

  depends_on "python@3.10"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz"
    sha256 "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/84/1b/1ecdd371fa68839cfbda15cc671d0f6c92d2c42688df995a9bf6e36f3511/coloredlogs-14.0.tar.gz"
    sha256 "a1fab193d2053aa6c0a97608c4342d031f1f93a3d1218432c59322441d31a505"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "fs" do
    url "https://files.pythonhosted.org/packages/1d/a1/8813629b38a8d97e8f1eceb6c7da03b37633c93104fbd8e30e09d195425a/fs-2.4.11.tar.gz"
    sha256 "cc99d476b500f993df8ef697b96dc70928ca2946a455c396a566efe021126767"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/6c/19/8e3b4c6fa7cca4788817db398c05274d98ecc6a35e0eaad2846fde90c863/humanfriendly-8.2.tar.gz"
    sha256 "bf52ec91244819c780341a3438d5d7b09f431d3f113a475147ac9b7b167a3d12"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f4/f6/94fee50f4d54f58637d4b9987a1b862aeb6cd969e73623e02c5c00755577/pytz-2020.1.tar.gz"
    sha256 "c35965d010ce31b23eeb663ed3cc8c906275d6be1a34393a1d73a41febf4a048"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/a9/26/dfe61bbfbe7d723fe76ff41960c96161fd32ff303be88bbbdfb428250cd4/tenacity-6.2.0.tar.gz"
    sha256 "29ae90e7faf488a8628432154bb34ace1cca58244c6ea399fd33f066ac71339a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/71/6c/6530032ec26dddd47bb9e052781bcbbcaa560f05d10cdaf365ecb990d220/tqdm-4.48.0.tar.gz"
    sha256 "6baa75a88582b1db6d34ce4690da5501d2a1cb65c34664840a456b2c9f794d29"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/05/8c/40cd6949373e23081b3ea20d5594ae523e681b6f472e600fbc95ed046a36/urllib3-1.25.9.tar.gz"
    sha256 "3018294ebefce6572a474f0604c2021e33b3fd8006ecd11d62107a5d2a963527"
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
