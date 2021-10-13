class Datalad < Formula
  include Language::Python::Virtualenv

  desc "Data distribution geared toward scientific datasets"
  homepage "https://www.datalad.org"
  url "https://files.pythonhosted.org/packages/36/00/e8a1f0ddc0a899d494aa9694f28ebff3b13c87276bc749ed29a1163ec868/datalad-0.15.2.tar.gz"
  sha256 "1a878cf521270f089ee1f50339e71cfd7eed41e708d895a12d5c483a9b59991b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "503698b2d43d533b47508cb1e3cbb383d13cbf9905af706762ada230fadd669b"
    sha256 cellar: :any_skip_relocation, catalina:     "9615cc1d8c198be8e3ddb464ba689bbc600b983d67fd1e23b66f01d755a7e0a7"
    sha256 cellar: :any_skip_relocation, mojave:       "6a981503291d9f07c2575403329eaf4194b4e1589a38356f19a059c1ecd6272e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cfdc331e5846d7c79bcdf54508c2d2ae9d3b78f05a6698d52ee9704dc270ab82"
  end

  depends_on "git-annex"
  depends_on "p7zip"
  depends_on "python@3.10"
  depends_on "six"

  resource "annexremote" do
    url "https://files.pythonhosted.org/packages/a1/2d/8cbc4b3a79a5e11589b4b0345f24580791a269b5641b05fb2e633d3bbe37/annexremote-1.5.0.tar.gz"
    sha256 "92f32b6f5461cbaeefe0c60b32f9c1e0c1dbe4e57b8ee425affb56f4060f64ef"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2e/92/87bb61538d7e60da8a7ec247dc048f7671afe17016cd0008b3b710012804/cffi-1.14.6.tar.gz"
    sha256 "c9a875ce9d7fe32887784274dd533c57909b7b1dcadcc128a2ac21331a9765dd"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/eb/7f/a6c278746ddbd7094b019b08d1b2187101b1f596f35f81dc27f57d8fcf7c/charset-normalizer-2.0.6.tar.gz"
    sha256 "5ec46d183433dcbd0ab716f2d7f29d8dee50505b3fdb40c6b985c7c4f5a3591f"
  end

  resource "Deprecated" do
    url "https://files.pythonhosted.org/packages/c8/d1/e412abc2a358a6b9334250629565fe12697ca1cdee4826239eddf944ddd0/Deprecated-1.2.13.tar.gz"
    sha256 "43ac5335da90c31c24ba028af536a91d41d53f9e6901ddb021bcc572ce44e38d"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a5/26/256fa167fe1bf8b97130b4609464be20331af8a3af190fb636a8a7efd7a2/distro-1.6.0.tar.gz"
    sha256 "83f5e5a09f9c5f68f60173de572930effbcc0287bb84fdc4426cb4168c088424"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/28/e4/2888d41cdbd405828ccdb9a8536c5919939c2f4c6ab9b2ba63e9bd2570d5/fasteners-0.16.3.tar.gz"
    sha256 "b1ab4e5adfbc28681ce44b3024421c4f567e705cc3963c732bf1cba3348307de"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/4f/95/e097e65913e9b5ce68a576cf3ea364eb240973cc15c6a8184047a3571290/humanize-3.12.0.tar.gz"
    sha256 "5ec1a66e230a3e31fb3f184aab9436ea13d4e37c168e0ffc345ae5bb57e58be6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/f0/70/ca3dd67cdd368b957e73a8156f7e1a10339f9813e314cb8b4549526070da/importlib_metadata-4.8.1.tar.gz"
    sha256 "f284b3e11256ad1e5d03ab86bb2ccd6f5339688ff17a4d797a0fe7df326f23b1"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/45/66/a943f702763c879e2754b46089a136ee1e58f0f720c58fa640c00281d3fd/iso8601-0.1.16.tar.gz"
    sha256 "36532f77cc800594e8f16641edae7f1baf7932f05d8e508545b95fc53c6dc85b"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/cc/24/c5402ba0c6380cc058980e2b73f0597ab6875692f185054a94244b7161ab/keyring-23.2.1.tar.gz"
    sha256 "6334aee6073db2fb1f30892697b1730105b5e9a77ce7e61fca6b435225493efe"
  end

  resource "keyrings.alt" do
    url "https://files.pythonhosted.org/packages/b8/a4/f9ef8a522e2f5bb273de6b5848bcb7d2fa4f0c1ea935fc8630762accb4db/keyrings.alt-4.1.0.tar.gz"
    sha256 "52ccb61d6f16c10f32f30d38cceef7811ed48e086d73e3bae86f0854352c4ab2"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/59/04/87fc6708659c2ed3b0b6d4954f270b6e931def707b227c4554f99bd5401e/msgpack-1.0.2.tar.gz"
    sha256 "fae04496f5bc150eefad4e9571d1a76c55d021325dcd484ce45065ebbdd00984"
  end

  resource "patool" do
    url "https://files.pythonhosted.org/packages/1b/eb/ad3c94cb8cbc1d8b1c47471d2c43537a05fda2bdff54a7d8248873591691/patool-1.12.tar.gz"
    sha256 "e3180cf8bfe13bedbcf6f5628452fca0c2c84a3b5ae8c2d3f55720ea04cb1097"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "PyGithub" do
    url "https://files.pythonhosted.org/packages/98/36/386d282903c572b18abc36de68aaf4146db4659c82dceee009ef88a86b67/PyGithub-1.55.tar.gz"
    sha256 "1bbfff9372047ff3f21d5cd8e07720f3dbfdaf6462fcaed9d815f528f1ba7283"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/b9/6d/e5ac4eb80724cb4201de6dcbc1e8a9f5cb65a0424b30c4c69e49bc1363d1/PyJWT-2.2.0.tar.gz"
    sha256 "a0b9a3b4e5ca5517cac9f1a6e9cd30bf1aa80be74fcdf4e28eded582ecfcfbae"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "python-gitlab" do
    url "https://files.pythonhosted.org/packages/4f/47/5c51420baf1ea3141d7da32a0a92541a5073491c8da8bd309e9ca52c5e8d/python-gitlab-2.10.1.tar.gz"
    sha256 "7afa7d7c062fa62c173190452265a30feefb844428efc58ea5244f3b9fc0d40f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310/requests-toolbelt-0.9.1.tar.gz"
    sha256 "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/01/52/41c71718f941c9a5abebfaa24e3c14e3c0229327b7ebd21348989845ed8f/simplejson-3.17.5.tar.gz"
    sha256 "91cfb43fb91ff6d1e4258be04eee84b51a4ef40a28d899679b9ea2556322fb50"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/e3/c1/b3e42d5b659ca598508e2a9ef315d5eef0a970f874ef9d3b38d4578765bd/tqdm-4.62.3.tar.gz"
    sha256 "d359de7217506c9851b7869f3708d8ee53ed70a1b8edbba4dbcb47442592920d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "Whoosh" do
    url "https://files.pythonhosted.org/packages/25/2b/6beed2107b148edc1321da0d489afc4617b9ed317ef7b72d4993cad9b684/Whoosh-2.7.4.tar.gz"
    sha256 "7ca5633dbfa9e0e0fa400d3151a8a0c4bec53bd2ecedc0a67705b17565c31a83"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/e2/30/dae34ff8afa579098e5796452c414efa4b2738afda40318fdb26e1a8edc1/wrapt-1.13.1.tar.gz"
    sha256 "909a80ce028821c7ad01bdcaa588126825931d177cdccd00b3545818d4a195ce"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/02/bf/0d03dbdedb83afec081fefe86cae3a2447250ef1a81ac601a9a56e785401/zipp-3.6.0.tar.gz"
    sha256 "71c644c5369f4a6e07636f0aa966270449561fcea2e3d6747b8d23efaa9d7832"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"datalad", "create", "-d", "testdata"
    assert_predicate testpath/"testdata", :exist?
  end
end
