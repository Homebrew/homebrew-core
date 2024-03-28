class Datalad < Formula
  include Language::Python::Virtualenv

  desc "Data distribution geared toward scientific datasets"
  homepage "https://www.datalad.org"
  url "https://files.pythonhosted.org/packages/57/2f/10e55c07277da8ba5e2fd989d8783c2539db249d1910484a43a0396aa7d6/datalad-0.19.6.tar.gz"
  sha256 "e0da2dbb1a9f233a18a652d59df3d63ebac3185a6713752e263e1f7b48e1c54c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38a1cc59f441bb063dcac41e159d1e5096d25230c862925b14e6a675398afc57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42a8a62af4b2ce1dfaef7c722a243cad24583d7dba784501b6cbd8bb37506ad4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51d57b384522b9d454bfd53ae0d44927a7c8a1996a30c9a4b727e0407e6c7c16"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3ae184bb84115287c09610e621bc4fc1dd9040f24d26867b1ee10886403e703"
    sha256 cellar: :any_skip_relocation, ventura:        "b2357563b83e7425dab4f24ee826d6430120355a815d85aa6e0a0dd63e055242"
    sha256 cellar: :any_skip_relocation, monterey:       "f3fd524a654e38f01d054a61bdac118db49e33df8bfab2bf08fecd44c58c8c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "285babb02e16ed1386a45a6911a1129ab38408d733d61f0a6c7841c282495d32"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "git-annex"
  depends_on "p7zip"
  depends_on "python@3.11" # Python 3.12 blocked by `boto` usage: https://github.com/datalad/datalad/issues/5597

  resource "annexremote" do
    url "https://files.pythonhosted.org/packages/30/a8/c2bd70b26edbb815cb8180344a7dd88ba9da5124b02b4434ddb25e0cc6d1/annexremote-1.6.4.tar.gz"
    sha256 "da4198a25b36c699216fd5f1e93ba0e655e167b6822b64284a4bf90388ea69ae"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/5f/d4/e834d929be54bfadb1f3e3b931c38e956aaa3b235a46a3c764c26c774902/fasteners-0.19.tar.gz"
    sha256 "b4f37c3ac52d8a445af3a66bce57b33b5e90b97c696b7b984f530cf8f0ded09c"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/76/21/7a0b24fae849562397efd79da58e62437243ae0fd0f6c09c6bc26225b75c/humanize-4.9.0.tar.gz"
    sha256 "582a265c931c683a7e9b8ed9559089dea7edcf6cc95be39a3cbc2c5d5ac2bcfa"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/90/b4/206081fca69171b4dc1939e77b378a7b87021b0f43ce07439d49d8ac5c84/importlib_metadata-7.0.1.tar.gz"
    sha256 "f238736bb06590ae52ac1fab06a3a9ef1d8dce2b7a35b5ab329371d6c8f5d2cc"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/8b/de/d0a466824ce8b53c474bb29344e6d6113023eb2c3793d1c58c0908588bfa/jaraco.classes-3.3.0.tar.gz"
    sha256 "c063dd08e89217cee02c8d5e5ec560f2c8ce6cdc2fcdc2e68f7b2e5547ed3621"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/69/cd/889c6569a7e5e9524bc1e423fd2badd967c4a5dcd670c04c2eff92a9d397/keyring-24.3.0.tar.gz"
    sha256 "e730ecffd309658a08ee82535a3b5ec4b4c8669a9be11efb66249d8e0aeb9a25"
  end

  resource "keyrings-alt" do
    url "https://files.pythonhosted.org/packages/a6/97/c7344bed881cc6f78b6231262436eb0c72615011fab4786d23d676ab77b0/keyrings.alt-5.0.0.tar.gz"
    sha256 "9d446cb47bbcea90ffa2ecc3e8003acf41573fc201bf44b4bf13bd0e11484828"
  end

  resource "looseversion" do
    url "https://files.pythonhosted.org/packages/64/7e/f13dc08e0712cc2eac8e56c7909ce2ac280dbffef2ffd87bd5277ce9d58b/looseversion-1.3.0.tar.gz"
    sha256 "ebde65f3f6bb9531a81016c6fef3eb95a61181adc47b7f949e9c0ea47911669e"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/df/ad/7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4/more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "patool" do
    url "https://files.pythonhosted.org/packages/35/9c/d4514a98e262824389e4a00272fa7e14b63fa114b96ef214f96502973bd7/patool-2.1.1.tar.gz"
    sha256 "d55d82694038aae18bc34be25ef29d042c244f93a03a4f66c8b4d218f927e7cb"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "python-gitlab" do
    url "https://files.pythonhosted.org/packages/8d/6d/934b832b55ca42740b078fe18aa83680ac7d196802feee39f9b87195a156/python-gitlab-4.4.0.tar.gz"
    sha256 "1d117bf7b433ae8255e5d74e72c660978f50ee85eb62248c9fb52ef43c3e3814"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/cc/abf6746cc90bc52df4ba730f301b89b3b844d6dc133cb89a01cfe2511eb9/urllib3-2.2.0.tar.gz"
    sha256 "051d961ad0c62a94e50ecf1af379c3aba230c66c710493493560c0c223c49f20"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/58/03/dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6/zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"datalad", "create", "-d", "testdata"
    assert_predicate testpath/"testdata", :exist?
  end
end
