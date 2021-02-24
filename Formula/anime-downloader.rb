class AnimeDownloader < Formula
  include Language::Python::Virtualenv

  desc "Download your favourite anime"
  homepage "https://github.com/vn-ki/anime-downloader"
  url "https://files.pythonhosted.org/packages/06/4f/5290202545ec964b442458410dd9623cde0327ee164036553f976b9ea601/anime-downloader-5.0.7.tar.gz"
  sha256 "04fe167f679f53545493a23ef36ac572f11dc4348aa274ce2198e6dc1d31ec48"
  license "Unlicense"
  head "https://github.com/vn-ki/anime-downloader.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3a202b4257f5b6b0a5eb94ae86cdae3980ac4a2ecd3d806e91c8750ac5ab8c2c"
    sha256 cellar: :any_skip_relocation, big_sur:       "8000f581b43794240687ae2792a266b1a61929d561e02388c90edccaf0f4b406"
    sha256 cellar: :any_skip_relocation, catalina:      "e76e47b8fd7b2feb747f78b5e58c33c8a2c52daac637eccfe88cae6fd1fccb2f"
    sha256 cellar: :any_skip_relocation, mojave:        "4ef176a388883c4fae8202f28023b6548ca6b12dfaf7e8ccf2821198edb8e859"
  end

  depends_on "aria2"
  depends_on "node"
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
    url "https://files.pythonhosted.org/packages/c4/3a/5bca2cb1648b171afd6b7d29a11c6bca8b305bb75b7e2d78a0f5c61ff95e/pycryptodome-3.9.9.tar.gz"
    sha256 "910e202a557e1131b1c1b3f17a63914d57aac55cf9fb9b51644962841c3995c4"
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
    url "https://files.pythonhosted.org/packages/58/5d/445e21e92345848305eecf473338e9ec7ed8905b99ea78415042060127fc/soupsieve-2.1.tar.gz"
    sha256 "6dc52924dc0bc710a5d16794e6b3480b2c7c08b07729505feab2b2c16661ff6e"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/57/6f/213d075ad03c84991d44e63b6516dd7d185091df5e1d02a660874f8f7e1e/tabulate-0.8.7.tar.gz"
    sha256 "db2723a20d04bcda8522165c73eea7c300eda74e0ce852d9022e0159d7895007"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d7/8d/7ee68c6b48e1ec8d41198f694ecdc15f7596356f2ff8e6b1420300cf5db3/urllib3-1.26.3.tar.gz"
    sha256 "de3eedaad74a2683334e282005cd8d7f22f4d55fa690a2a1020a416cb0a47e73"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Download or watch your favourite anime", shell_output("#{bin}/anime --help 2>&1")

    assert_equal "anime, version #{version}", shell_output("#{bin}/anime --version").chomp
  end
end
