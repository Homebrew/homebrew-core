class BandcampDl < Formula
  include Language::Python::Virtualenv

  desc "Simple python script to download Bandcamp albums"
  homepage "https://github.com/iheanyi/bandcamp-dl"
  url "https://github.com/iheanyi/bandcamp-dl/archive/0.0.10.tar.gz"
  sha256 "778899a166d5c242a75eef7f95b7e8b2dba7b8e8fcaa7a8f8e5ae64b13afefc2"
  license "Unlicense"
  head "https://github.com/iheanyi/bandcamp-dl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0e19f971b88b0ff7e673f453e0d88913f82e4f8d1c4accda8321092fceb68bc" => :big_sur
    sha256 "add76c38806f7f310dd34946916d70cb4db029c4ef3694cc64592deb9921dc2b" => :arm64_big_sur
    sha256 "ee51b1cdb255665578251bd7081ae2a01abcca24d48d72eed076b9a8794af58c" => :catalina
    sha256 "d416f44eae62f3a83be9ea4312cb244581772df264c9c8156165dde038144f56" => :mojave
    sha256 "f1d7e4a182af86854f3218cf6812fa7975d922a0ee3e8c3b5c9ee16741b0eb1c" => :high_sierra
  end

  depends_on "python@3.9"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/6b/c3/d31704ae558dcca862e4ee8e8388f357af6c9d9acb0cad4ba0fbbd350d9a/beautifulsoup4-4.9.3.tar.gz"
    sha256 "84729e322ad1d5b4d25f805bfa05b902dd96450f43842c4e99067d5e1369eb25"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "demjson" do
    url "https://files.pythonhosted.org/packages/96/67/6db789e2533158963d4af689f961b644ddd9200615b8ce92d6cad695c65a/demjson-2.2.4.tar.gz"
    sha256 "31de2038a0fdd9c4c11f8bf3b13fe77bc2a128307f965c8d5fb4dc6d6f6beb79"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/e2/be/3ea39a8fd4ed3f9a25aae18a1bff2df7a610bca93c8ede7475e32d8b73a0/mock-4.0.3.tar.gz"
    sha256 "7d3fbbde18228f4ff2f1f119a45cdffa458b4c0dee32eb4d2bb2f82554bac7bc"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/f3/d9/2232a4cb9a98e2d2501f7e58d193bc49c956ef23756d7423ba1bd87e386d/mutagen-1.45.1.tar.gz"
    sha256 "6397602efb3c2d7baebd2166ed85731ae1c1d475abca22090b7141ff5034b3e1"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/58/5d/445e21e92345848305eecf473338e9ec7ed8905b99ea78415042060127fc/soupsieve-2.1.tar.gz"
    sha256 "6dc52924dc0bc710a5d16794e6b3480b2c7c08b07729505feab2b2c16661ff6e"
  end

  resource "unicode-slugify" do
    url "https://files.pythonhosted.org/packages/8c/ba/1a05f61c7fd72df85ae4dc1c7967a3e5a4b6c61f016e794bc7f09b2597c0/unicode-slugify-0.1.3.tar.gz"
    sha256 "34cf3afefa6480efe705a4fc0eaeeaf7f49754aec322ba3e8b2f27dc1cbcf650"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/45/dd/544c34ddf9ab0ead3746110ad6fbdac26ca5f4a1666db22dc8aaf447d0c9/Unidecode-1.1.2.tar.gz"
    sha256 "a039f89014245e0cad8858976293e23501accc9ff5a7bdbc739a14a2b7b85cdc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/29/e6/d1a1d78c439cad688757b70f26c50a53332167c364edb0134cadd280e234/urllib3-1.26.2.tar.gz"
    sha256 "19188f96923873c92ccb987120ec4acaa12f0461fa9ce5d3d0772bc965a39e08"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/bandcamp-dl", "--artist=iamsleepless", "--album=rivulets"
    assert_predicate testpath/"iamsleepless/rivulets/01 - rivulets.mp3", :exist?
    system "#{bin}/bandcamp-dl", "https://iamsleepless.bandcamp.com/track/under-the-glass-dome"
    assert_predicate testpath/"iamsleepless/under-the-glass-dome/Single - under-the-glass-dome.mp3", :exist?
  end
end
