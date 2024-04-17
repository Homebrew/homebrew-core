class Datalad < Formula
  include Language::Python::Virtualenv

  desc "Data distribution geared toward scientific datasets"
  homepage "https://www.datalad.org"
  url "https://files.pythonhosted.org/packages/ee/51/43be9521b4942bf5db7e218e8802e747b4aa7fd8a7c7be80580a8e63232b/datalad-1.0.0.tar.gz"
  sha256 "34113a9fdd2f8fa2aa6124a89a2853e83a3604f6b31eeaf5f9161def0da692e7"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27fad2dc1d9684e75572968a34665f9f6b2961f3fa4f062ce31d7f219e63acc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c439f2fbf25957b8dbac2b177b11607e3556fbb62233d3c7a1c5b2c30737c7ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f450676050718875b2ddbc3c2fcdaebf184b3c2b4abce2df02b3eb6827214a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea35f60827921e0885dc69bdb12411995d21eaed45ec83506d50f95d9bec711d"
    sha256 cellar: :any_skip_relocation, ventura:        "f8d1cb5b0a2a3cf1cca56a88b037c07f0562ced2c945fdd2c3b33008dbb07362"
    sha256 cellar: :any_skip_relocation, monterey:       "8d054cf5bd220f8c63623e9e6aa1a87fe93a56d901e8e1ee6f629ed4785c8d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4d401bfa08fc504247c680936aeff55ac7d2890c0b68c25fceeafba92ee606d"
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

  resource "backports-tarfile" do
    url "https://files.pythonhosted.org/packages/1d/f5/2f268125bdd8f6d5cce1d6ba19fc0c58a6d65d3f46f27df677236d58620a/backports.tarfile-1.0.0.tar.gz"
    sha256 "2688f159c21afd56a07b75f01306f9f52c79aebcc5f4a117fb8fbb4445352c75"
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
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a0/fc/c4e6078d21fc4fa56300a241b87eae76766aa380a23fc450fc85bb7bf547/importlib_metadata-7.1.0.tar.gz"
    sha256 "b78938b926ee8d5f020fc4772d487045805a55ddbad2ecf21c6d60938dc7fcd2"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/c9/60/e83781b07f9a66d1d102a0459e5028f3a7816fdd0894cba90bee2bbbda14/jaraco.context-5.3.0.tar.gz"
    sha256 "c2f67165ce1f9be20f32f650f25d8edfc1646a8aeee48ae06fb35f90763576d2"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/57/7c/fe770e264913f9a49ddb9387cca2757b8d7d26f06735c1bfbb018912afce/jaraco.functools-4.0.0.tar.gz"
    sha256 "c279cb24c93d694ef7270f970d499cab4d3813f4e08273f95398651a634f0925"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/18/ec/cc0afdcd7538d4942a6b78f858139120a8c7999e554004080ed312e43886/keyring-25.1.0.tar.gz"
    sha256 "7230ea690525133f6ad536a9b5def74a4bd52642abe594761028fc044d7c7893"
  end

  resource "keyrings-alt" do
    url "https://files.pythonhosted.org/packages/4f/55/7a52c9961f607353034945692c700ab648f18ea2ab2d509e248b24cb0a91/keyrings.alt-5.0.1.tar.gz"
    sha256 "cd372a1ec446a1bc5a90624a52c88e83b9330218e39047a6c9a48ae37d116745"
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
    url "https://files.pythonhosted.org/packages/08/4c/17adf86a8fbb02c144c7569dc4919483c01a2ac270307e2d59e1ce394087/msgpack-1.0.8.tar.gz"
    sha256 "95c02b0e27e706e48d0e5426d1710ca78e0f0628d6e89d5b5a5b91a5f12274f3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "patool" do
    url "https://files.pythonhosted.org/packages/97/f3/4631a690c5620e39e03e1e6768f68f5cfe766004311e66d1c17bcd9f293b/patool-2.2.0.tar.gz"
    sha256 "7767a747b24fbaa6ecc53579debc18358b6bc792ddb57e0669784c5b29af4a73"
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

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/ea/85/3ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8/tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3e/ef/65da662da6f9991e87f058bc90b91a935ae655a16ae5514660d6460d1298/zipp-3.18.1.tar.gz"
    sha256 "2884ed22e7d8961de1c9a05142eb69a247f120291bc0206a00a7642f09b5b715"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"datalad", "create", "-d", "testdata"
    assert_predicate testpath/"testdata", :exist?
  end
end
