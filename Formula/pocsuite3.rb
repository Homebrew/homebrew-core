class Pocsuite3 < Formula
  include Language::Python::Virtualenv

  desc "Open-sourced remote vulnerability testing framework"
  homepage "https://pocsuite.org/"
  url "https://files.pythonhosted.org/packages/11/93/0d9c8b8a43dfc931d83d4693f7774d8e64b13d86e46da918fc16ad6b7927/pocsuite3-2.0.2.tar.gz"
  sha256 "22bad4683d7626632094457609c4377cdff9895879e7e3405f22e3fd54b41d78"
  license "GPL-2.0-only"
  head "https://github.com/knownsec/pocsuite3.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "d563ba4dbd250c68b225b9d7a9190d6edc5a7de55d2655516b862f94f90305fd"
    sha256 cellar: :any,                 arm64_monterey: "4e07d121cc138acf5b7aa7adc6f1292527aecd9609b16cee7410e3b3c5419723"
    sha256 cellar: :any,                 arm64_big_sur:  "49f81cc9c3ebb8a0587831549accc761c265e6a541b60f78ba927df185a06192"
    sha256 cellar: :any,                 ventura:        "9a7ba83e501813f0ff9b4918afefdcead5b367b3946c2f64ff521c099b5f69f7"
    sha256 cellar: :any,                 monterey:       "a9f0f4076b546e0c2057069587d6bf9333fe09d897f75d2803ced827c70e17a6"
    sha256 cellar: :any,                 big_sur:        "5d713f81e25863b58fe74dddf8bbb1f43b07a5a93d38067354c5c332522afa1e"
    sha256 cellar: :any,                 catalina:       "4ea99ee6182a358c133fbe1278401df48f93bd59855bb1f1350a9070a83d4a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af0758a786a896d773225f2ca8bb75213aefc773c34eb5f491b8f5e4cff39381"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/41/32/cdc91dcf83849c7385bf8e2a5693d87376536ed000807fa07f5eab33430d/chardet-5.1.0.tar.gz"
    sha256 "0d62712b956bc154f85fb0a266e2a3c5913c2967e00348701b32411d6def31e5"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/78/6b/4e5481ddcdb9c255b2715f54c863629f1543e97bc8c309d1c5c131ad14f2/colorlog-6.7.0.tar.gz"
    sha256 "bd94bd21c1e13fac7bd3153f4bc3a7dc0eb0974b8bc2fdf1a989e474f6e582e5"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/e3/3f/41186b1f2fd86a542d399175f6b8e43f82cd4dfa51235a0b030a042b811a/cryptography-38.0.4.tar.gz"
    sha256 "175c1a818b87c9ac80bb7377f5520b7f31b3ef2a0004e2420319beadedb67290"
  end

  resource "dacite" do
    url "https://files.pythonhosted.org/packages/f9/bf/3f0912b4cfd861cd0fb7278c2b8d5bfb0c613ec1b7922e25e4115287b73a/dacite-1.6.0.tar.gz"
    sha256 "d48125ed0a0352d3de9f493bf980038088f45f3f9d7498f090b50a847daaa6df"
  end

  resource "Faker" do
    url "https://files.pythonhosted.org/packages/f7/4c/fa7aa83aa53c641798a338ceaee200a22a988b367323b118c962855be580/Faker-15.3.4.tar.gz"
    sha256 "2d5443724f640ce07658ca8ca8bbd40d26b58914e63eec6549727869aa67e2cc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jq" do
    url "https://files.pythonhosted.org/packages/ae/6e/86eef3c07cef9d942173105046118f9cebc6d4c7a9c64b1766738247e167/jq-1.3.0.tar.gz"
    sha256 "96b66f41a91c9794f8051cc32d8fd3206c6409693f0076b22eacb4faa0bc504f"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "mmh3" do
    url "https://files.pythonhosted.org/packages/4a/54/78c7f04ceee4913cbe7b33e253867c1da2291c80dfa6062dc6aaabb6cef8/mmh3-3.0.0.tar.gz"
    sha256 "d1ec578c09a07d3518ec9be540b87546397fa3455de73c166fcce51eaa5c41c5"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/63/42/b8b24cfe616a8217515011fc54ed37b45077cd4467230b3a0132166696a1/prettytable-3.4.0.tar.gz"
    sha256 "d16747b5108c252bf065ea1cd239aab3c87bd8bb10a9f7973c9f192bbcfed26e"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/5d/22/575c7dd7c86843e07a791cfa2143e7292d6b380f5a7cce966a49b9d6c9f4/pycryptodomex-3.16.0.tar.gz"
    sha256 "e9ba9d8ed638733c9e95664470b71d624a6def149e2db6cc52c1aca5a6a2df1d"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/e7/2f/c6d89edac75482f11e231b644e365d31d5479b7b727734e6a8f3d00decd5/pyOpenSSL-22.1.0.tar.gz"
    sha256 "7a83b7b272dd595222d672f5ce29aa030f1fb837630ef229f62e72e395ce8968"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/0c/4c/07f01c6ac44f7784fa399137fbc8d0cdc1b5d35304e8c0f278ad82105b58/requests-toolbelt-0.10.1.tar.gz"
    sha256 "62e09f7ff5ccbda92772a29f394a49c3ad6cb181d568b1337626b2abb628a63d"
  end

  resource "scapy" do
    url "https://files.pythonhosted.org/packages/85/47/c919432ca258f354bb2c1e645623f891603f185bfc7563d4a21f6432e7ed/scapy-2.4.5.tar.gz"
    sha256 "bc707e3604784496b6665a9e5b2a69c36cc9fb032af4864b29051531b24c8593"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/19/da/ff1f0906818a5bd2e69e773d88801ca3c9e92d0d7caa99db1665658819ea/termcolor-2.1.1.tar.gz"
    sha256 "67cee2009adc6449c650f6bcf3bdeed00c8ba53a8cda5362733c53e0a39fb70b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Module (pocs_ecshop_rce) options:", shell_output("#{bin}/pocsuite -k ecshop --options")
  end
end
