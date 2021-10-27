class AnimeDownloader < Formula
  include Language::Python::Virtualenv

  desc "Download your favourite anime"
  homepage "https://github.com/anime-dl/anime-downloader"
  url "https://files.pythonhosted.org/packages/00/8b/2f354c0c2e56f1fe45e805698bd6a81c472473a48b814c44aaed2d41016d/anime-downloader-5.0.9.tar.gz"
  sha256 "40eaded9508a30f35993b2fc0f436c357d9939d58625a10bd595bfc11816ead4"
  license "Unlicense"
  head "https://github.com/anime-dl/anime-downloader.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c56a2f2880ad0f27d82283fa496ed29920a55e06c24e9e294edafea385e7c872"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51528ac11b71b803cec6866244164cc4b5e837fbc189c38cdb054bf189ef59f7"
    sha256 cellar: :any_skip_relocation, monterey:       "fde42013e865de24caed2210d8b72a48e78b77f39d9058ae93872dd453479af2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b7f8ef5058b22b72b3f5bda4ad9110c9d4ab4e7bc9aa5cf9691ca5f0c5ea558"
    sha256 cellar: :any_skip_relocation, catalina:       "ca0111a1386a2269340b3ce8b7d7a24766975cc680ab60e4c045cadae989e106"
    sha256 cellar: :any_skip_relocation, mojave:         "b561d3e6d9c25da1d6088154ce894985d5e6d0b08d317566e31ee9a970dc1754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0f571445d312cada1fb7ce349655e378ef21cfd7e227780a8dad74a58671f7d"
  end

  depends_on "aria2"
  depends_on "node"
  depends_on "python-tabulate"
  depends_on "python@3.9"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/6b/c3/d31704ae558dcca862e4ee8e8388f357af6c9d9acb0cad4ba0fbbd350d9a/beautifulsoup4-4.9.3.tar.gz"
    sha256 "84729e322ad1d5b4d25f805bfa05b902dd96450f43842c4e99067d5e1369eb25"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "cfscrape" do
    url "https://files.pythonhosted.org/packages/a6/3d/12044a9a927559b2fe09d60b1cd6cd4ed1e062b7a28f15c91367b9ec78f1/cfscrape-2.1.1.tar.gz"
    sha256 "7c5ef94554e0d6ee7de7cd0d42051526e716ce6c0357679ee0b82c49e189e2ef"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/ce/ef/bfca8e38c1802896f67045a0c9ea0e44fc308b182dbec214b9c2dd54429a/coloredlogs-15.0.tar.gz"
    sha256 "5e78691e2673a8e294499e1832bb13efcfb44a86b92e18109fa18951093218ab"
  end

  resource "fuzzywuzzy" do
    url "https://files.pythonhosted.org/packages/11/4b/0a002eea91be6048a2b5d53c5f1b4dafd57ba2e36eea961d05086d7c28ce/fuzzywuzzy-0.18.0.tar.gz"
    sha256 "45016e92264780e58972dca1b3d939ac864b78437422beecebb3095f8efd00e8"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/31/0e/a2e882aaaa0a378aa6643f4bbb571399aede7dbb5402d3a1ee27a201f5f3/humanfriendly-9.1.tar.gz"
    sha256 "066562956639ab21ff2676d1fda0b5987e985c534fc76700a19bd54bcb81121d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/88/7f/740b99ffb8173ba9d20eb890cc05187677df90219649645aca7e44eb8ff4/pycryptodome-3.10.1.tar.gz"
    sha256 "3e2e3a06580c5f190df843cdb90ea28d61099cf4924334d5297a995de68e4673"
  end

  resource "pySmartDL" do
    url "https://files.pythonhosted.org/packages/5a/4c/ed073b2373f115094a4a612431abe25b58e542bebd951557dcc881999ef9/pySmartDL-1.3.4.tar.gz"
    sha256 "35275d1694f3474d33bdca93b27d3608265ffd42f5aeb28e56f38b906c0c35f4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/0c/d4/bdc22aad6979ceeea2638297f213108aeb5e25c7b103fa02e4acbe43992e/requests-cache-0.5.2.tar.gz"
    sha256 "813023269686045f8e01e2289cc1e7e9ae5ab22ddd1e2849a9093ab3ab7270eb"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/c8/3f/e71d92e90771ac2d69986aa0e81cf0dfda6271e8483698f4847b861dd449/soupsieve-2.2.1.tar.gz"
    sha256 "052774848f448cf19c7e959adf5566904d525f33a3f8b6ba6f6f8f26ec7de0cc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/cb/cf/871177f1fc795c6c10787bc0e1f27bb6cf7b81dbde399fd35860472cecbc/urllib3-1.26.4.tar.gz"
    sha256 "e7b021f7241115872f92f43c6508082facffbd1c048e3c6e2bb9c2a157e28937"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Download or watch your favourite anime", shell_output("#{bin}/anime --help 2>&1")

    assert_equal "anime, version #{version}", shell_output("#{bin}/anime --version").chomp
  end
end
