class Gyb < Formula
  include Language::Python::Virtualenv
  desc "CLI for backing up and restoring Gmail messages"
  homepage "https://github.com/GAM-team/got-your-back/"
  url "https://github.com/GAM-team/got-your-back/archive/refs/tags/v1.80.tar.gz"
  sha256 "171aa8d50d833f1d878337150a0cc99d9bfd26b9b922da244de94775a4ec251b"
  license "Apache-2.0"
  head "https://github.com/GAM-team/got-your-back.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0dbb19d224820e48911aea2679b6751b34623714e25407790df111e2001b6db7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b21ea33ad2d265741f7fddce0102ede0f5b60f30c212c0aeccac782471f09db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cb738fb7d86a0dae64b37db71a23cafd9c4c3cd0a600581a003fa7560027d8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "abac3bb4c139344c3188c16388b511a2f736a3fc53613daaeb3492765e93e637"
    sha256 cellar: :any_skip_relocation, ventura:        "3aaccd96d6c2ad210a407543794a6474eff0bde11886742beb91941005b5ff52"
    sha256 cellar: :any_skip_relocation, monterey:       "84599bbd79ce3ee0511be15fd7a62e6f6ab63609896f977c2e35fa6a0b1d3932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bf46d6ec62b1f3cfbaf289b797c831811d1bb13691811d62ddee6584cea79bf"
  end

  depends_on "pyinstaller" => :build
  depends_on "python-certifi" => :build
  depends_on "python-pyparsing" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => :build
  depends_on "rust" => :build # for cryptography
  depends_on "six" => :build

  uses_from_macos "zlib"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/10/21/1b6880557742c49d5b0c4dcf0cf544b441509246cdd71182e0847ac859d5/cachetools-5.3.2.tar.gz"
    sha256 "086ee420196f7b2ab9ca2db2520aca326318b68fe5ba8bc4d49cca91add450f2"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/2c/e4/56b14d35057a23cab9067dd8fb841407d05d32b5d6c7a3c66c1360e8a7c0/google-api-core-2.15.0.tar.gz"
    sha256 "abc978a72658f14a2df1e5e12532effe40f94f868f6e23d95133bd6abcca35ca"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/47/5f/2cb762b9996a4c3644a1efe602043ca178f3b63cce051bb83b729a04bead/google-api-python-client-2.114.0.tar.gz"
    sha256 "e041bbbf60e682261281e9d64b4660035f04db1cccba19d1d68eebc24d1465ed"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/9a/a7/96f6b41c736ac080844a96d34896019127427e66f59d6b03e001d243c6c6/google-auth-2.26.2.tar.gz"
    sha256 "97327dbbf58cccb58fc5a1712bba403ae76668e64814eb30f7316f7e27126b81"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/44/77/7433818d44cadd1964473b1d9ab5ecea36e6f951cf2b5188e08f7ebd5dab/google-auth-oauthlib-1.2.0.tar.gz"
    sha256 "292d2d3783349f2b0734a0a0207b1e1e322ac193c2c09d8f7c613fb7cc501ea8"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/4a/5f/eb12d721b45d20a977289d674e179995a0ddab1684d2c61b29a63d43a5f1/googleapis-common-protos-1.62.0.tar.gz"
    sha256 "83f0ece9f94e5672cced82f592d2a5edf527a96ed1794f0bab36d5735c996277"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/db/a5/05ea470f4e793c9408bc975ce1c6957447e3134ce7f7a58c13be8b2c216f/protobuf-4.25.2.tar.gz"
    sha256 "fe599e175cb347efc8ee524bcd4b902d11f7262c0e569ececcb89995c15f0a5e"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ce/dc/996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7/pyasn1-0.5.1.tar.gz"
    sha256 "6d391a96e59b23130a5cfa74d6fd7f388dbbe26cc8f1edf39fdddf08d9d6676c"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/3b/e4/7dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070f/pyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def python3
    "python3.12"
  end

  def install
    # change user config location from default of executable own path
    inreplace "gyb.py", "default=getProgPath()",
                        "default='#{pkgetc}'"
    venv = virtualenv_create(buildpath, python3)
    venv.pip_install resources

    ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python3)
    pyinstaller = Formula["pyinstaller"].opt_bin/"pyinstaller"
    system pyinstaller, "gyb.spec"
    bin.install "dist/gyb"
  end

  def post_install
    pkgetc.mkpath
  end

  def caveats
    <<~EOS
      Default config_folder: #{pkgetc}
    EOS
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/gyb --version 2>&1")
    # Below throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdated/too new/etc.
    assert_match "ERROR: --email is required.", shell_output("#{bin}/gyb", 1)
  end
end
