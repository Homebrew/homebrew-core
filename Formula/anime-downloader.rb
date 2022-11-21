class AnimeDownloader < Formula
  include Language::Python::Virtualenv

  desc "Download your favourite anime"
  homepage "https://github.com/anime-dl/anime-downloader"
  url "https://files.pythonhosted.org/packages/00/8b/2f354c0c2e56f1fe45e805698bd6a81c472473a48b814c44aaed2d41016d/anime-downloader-5.0.9.tar.gz"
  sha256 "40eaded9508a30f35993b2fc0f436c357d9939d58625a10bd595bfc11816ead4"
  license "Unlicense"
  revision 2
  head "https://github.com/anime-dl/anime-downloader.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af6aefac7fd2d26f0f0712544d6214e292f6c0b3df0d46af8a4ffe24623098ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3aada71979ba35b08c9241fb9473e8d59fc8dfbd798d5243edb68a009be422ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67054ab49350a67b144621caf72b5bbc0df2218cc1cbd9986d9e4ca7dff062e0"
    sha256 cellar: :any_skip_relocation, ventura:        "187f677a3c1222e5158d2a4920c4ebaa44187d24adb191c684737b93854d7c71"
    sha256 cellar: :any_skip_relocation, monterey:       "df4e94952b8fb14b91611e0b512da1a44a75f9032bdf0c5598ad70a22c362521"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc25d3a02ad10ea6156707f818ae3d0a8eb4a117999fa0a70f4593214f3c21cf"
    sha256 cellar: :any_skip_relocation, catalina:       "2df98ab6e5a8f81c488d6958652394325482abfc4e5df1a44919222649dafd85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75f11f974bff7f7da6b7fa87617d8eea00e0ebdbe36fbc521cc4b181bff135f0"
  end

  depends_on "aria2"
  depends_on "libpython-tabulate"
  depends_on "node"
  depends_on "python@3.11"
  depends_on "six"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/e8/b0/cd2b968000577ec5ce6c741a54d846dfa402372369b8b6861720aa9ecea7/beautifulsoup4-4.11.1.tar.gz"
    sha256 "ad9aa55b65ef2808eb405f46cf74df7fcb7044d5cbc26487f96eb2ef2e436693"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/fc/da/ff3239eb4241cbc6f8b69f53d4ca27a178d51f9e5a954f1a3588c8227dc5/cattrs-22.2.0.tar.gz"
    sha256 "f0eed5642399423cf656e7b66ce92cdc5b963ecafd041d1b24d136fdde7acf6d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "cfscrape" do
    url "https://files.pythonhosted.org/packages/a6/3d/12044a9a927559b2fe09d60b1cd6cd4ed1e062b7a28f15c91367b9ec78f1/cfscrape-2.1.1.tar.gz"
    sha256 "7c5ef94554e0d6ee7de7cd0d42051526e716ce6c0357679ee0b82c49e189e2ef"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
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
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/11/e4/a8e8056a59c39f8c9ddd11d3bc3e1a67493abe746df727e531f66ecede9e/pycryptodome-3.15.0.tar.gz"
    sha256 "9135dddad504592bcc18b0d2d95ce86c3a5ea87ec6447ef25cfedea12d6018b8"
  end

  resource "pySmartDL" do
    url "https://files.pythonhosted.org/packages/5a/4c/ed073b2373f115094a4a612431abe25b58e542bebd951557dcc881999ef9/pySmartDL-1.3.4.tar.gz"
    sha256 "35275d1694f3474d33bdca93b27d3608265ffd42f5aeb28e56f38b906c0c35f4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/66/02/40737a22e3c006830433d6dc9e9d6debb52d9e9e412bab16d82c50d7be14/requests_cache-0.9.7.tar.gz"
    sha256 "b7c26ea98143bac7058fad6e773d56c3442eabc0da9ea7480af5edfc134ff515"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/f3/03/bac179d539362319b4779a00764e95f7542f4920084163db6b0fd4742d38/soupsieve-2.3.2.post1.tar.gz"
    sha256 "fc53893b3da2c33de295667a0e19f078c14bf86544af307354de5fcf12a3f30d"
  end

  resource "url-normalize" do
    url "https://files.pythonhosted.org/packages/ec/ea/780a38c99fef750897158c0afb83b979def3b379aaac28b31538d24c4e8f/url-normalize-1.4.3.tar.gz"
    sha256 "d23d3a070ac52a67b83a1c59a0e68f8608d1cd538783b401bc9de2c0fac999b2"

    # Switch build-system to poetry-core to avoid rust dependency on Linux.
    # Remove in the next release of url-normalize
    patch do
      url "https://github.com/niksite/url-normalize/commit/b8557b10c977b191cc9d37e6337afe874a24ad08.patch?full_index=1"
      sha256 "b24bf01ec8d6c163a6d3c97672beba761d35006922d4ad930dbeca79b6c52bfe"
    end
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Download or watch your favourite anime", shell_output("#{bin}/anime --help 2>&1")

    assert_equal "anime, version #{version}", shell_output("#{bin}/anime --version").chomp
  end
end
