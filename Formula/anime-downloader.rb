class AnimeDownloader < Formula
  include Language::Python::Virtualenv

  desc "Download your favourite anime"
  homepage "https://github.com/anime-dl/anime-downloader"
  url "https://files.pythonhosted.org/packages/00/8b/2f354c0c2e56f1fe45e805698bd6a81c472473a48b814c44aaed2d41016d/anime-downloader-5.0.9.tar.gz"
  sha256 "40eaded9508a30f35993b2fc0f436c357d9939d58625a10bd595bfc11816ead4"
  license "Unlicense"
  revision 1
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
  depends_on "python@3.10"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/a1/69/daeee6d8f22c997e522cdbeb59641c4d31ab120aba0f2c799500f7456b7e/beautifulsoup4-4.10.0.tar.gz"
    sha256 "c23ad23c521d818955a4151a67d81580319d4bf548d3d49f4223ae041ff98891"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/d3/6f/7f753ab5bff9c2522398437f9b08879b890a2ac4d880654029b9302a0a0b/cattrs-1.8.0.tar.gz"
    sha256 "5c121ab06a7cac494813c228721a7feb5a6423b17316eeaebf13f5a03e5b0d53"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cfscrape" do
    url "https://files.pythonhosted.org/packages/a6/3d/12044a9a927559b2fe09d60b1cd6cd4ed1e062b7a28f15c91367b9ec78f1/cfscrape-2.1.1.tar.gz"
    sha256 "7c5ef94554e0d6ee7de7cd0d42051526e716ce6c0357679ee0b82c49e189e2ef"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2f/39/5d8ff929409113e9ff402e405a7c7880ab1fa6f118a4ab72443976a01711/charset-normalizer-2.0.8.tar.gz"
    sha256 "735e240d9a8506778cd7a453d97e817e536bb1fc29f4f6961ce297b9c7a917b0"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/cc/c7/eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325/coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "fuzzywuzzy" do
    url "https://files.pythonhosted.org/packages/11/4b/0a002eea91be6048a2b5d53c5f1b4dafd57ba2e36eea961d05086d7c28ce/fuzzywuzzy-0.18.0.tar.gz"
    sha256 "45016e92264780e58972dca1b3d939ac864b78437422beecebb3095f8efd00e8"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/64/ab/f2b4059ddf59bffbdbb4bdb60a6729c6c1de5eea1ef186d5a633ae12db3b/pycryptodome-3.11.0.tar.gz"
    sha256 "428096bbf7a77e207f418dfd4d7c284df8ade81d2dc80f010e92753a3e406ad0"
  end

  resource "pySmartDL" do
    url "https://files.pythonhosted.org/packages/5a/4c/ed073b2373f115094a4a612431abe25b58e542bebd951557dcc881999ef9/pySmartDL-1.3.4.tar.gz"
    sha256 "35275d1694f3474d33bdca93b27d3608265ffd42f5aeb28e56f38b906c0c35f4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/12/c2/cbdf169cb621aeb8b0f1097e357b65e018a30079501fc88c9f889ad61b00/requests-cache-0.8.1.tar.gz"
    sha256 "27d3eb276ab3affa9864dfc0475241d6d960dd566d57ec46ffa7759c2c74ed1c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/e1/25/a3005eedafb34e1258458e8a4b94900a60a41a2b4e459e0e19631648a2a0/soupsieve-2.3.1.tar.gz"
    sha256 "b8d49b1cd4f037c7082a9683dfa1801aa2597fb11c3a1155b7a5b94829b4f1f9"
  end

  resource "url-normalize" do
    url "https://files.pythonhosted.org/packages/ec/ea/780a38c99fef750897158c0afb83b979def3b379aaac28b31538d24c4e8f/url-normalize-1.4.3.tar.gz"
    sha256 "d23d3a070ac52a67b83a1c59a0e68f8608d1cd538783b401bc9de2c0fac999b2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Download or watch your favourite anime", shell_output("#{bin}/anime --help 2>&1")

    assert_equal "anime, version #{version}", shell_output("#{bin}/anime --version").chomp
  end
end
