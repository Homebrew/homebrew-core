class AwsGoogleAuth < Formula
  include Language::Python::Virtualenv

  desc "Acquire AWS credentials using Google Apps"
  homepage "https://github.com/cevoaustralia/aws-google-auth"
  url "https://files.pythonhosted.org/packages/17/42/b466b9376f88f27d4d251b2e61194879a840b7be0c3a6808bc20381b2d5e/aws-google-auth-0.0.37.tar.gz"
  sha256 "0cc76e88ac188a26a484faffb21f1c7f31c0c56932aa30e6772e17245d0eb7cc"
  license "MIT"
  revision 5
  head "https://github.com/cevoaustralia/aws-google-auth.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "321c82a61fd5bc13bb146381deb4e36f14c4f89c174080978e33b515e6c18891"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "628009536555d056af3826e065c8047e1bc302f22c7450ba4fd70bec73050412"
    sha256 cellar: :any_skip_relocation, monterey:       "cce4d8d9c5189d80c9c3ca6e4da31eaaae9c3a37089f953fe69c65ea600aef7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b74276c314d890907b505220f458e4a63de0000326976bcdf0d16ffebb9adae8"
    sha256 cellar: :any_skip_relocation, catalina:       "f4894c241f651b541171f743fa255946e9134c139de37fd4b732ef56c87a0db6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0af5bbd9774b7548ae82c17d9865f4955d050d7cba56efc6c907500215735598"
  end

  depends_on "rust" => :build
  depends_on "pillow"
  depends_on "python-tabulate"
  depends_on "python@3.10"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/a1/69/daeee6d8f22c997e522cdbeb59641c4d31ab120aba0f2c799500f7456b7e/beautifulsoup4-4.10.0.tar.gz"
    sha256 "c23ad23c521d818955a4151a67d81580319d4bf548d3d49f4223ae041ff98891"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/47/d1/297648c2aaa4f4daa9856598036b78b75c4e4d9533d1606f90fed19a6603/boto3-1.20.19.tar.gz"
    sha256 "555680f12dd5cf6aa040d5693a45e14f991f05a5d81f84736653ff19b0de7e83"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/c1/50/66892179b26c82d05ce594ee93743311bee7e3289611eab4c9a11e11969b/botocore-1.23.19.tar.gz"
    sha256 "ba676114d8aaeb6d37c333f7094d050b27354c6b4c4fb54407520f1ecd139328"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/d4/ae/790bdb30a06d78f1bdd4c3fe147fd2aeef0b58f7111e5f24f11078aa5697/configparser-5.1.0.tar.gz"
    sha256 "202b9679a809b703720afa2eacaad4c6c2d63196070e5d9edc953c0489dfd536"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/79/3f/aae4a951dc5bd2738901e053c057f4b317bf12199f09351f63a002442117/filelock-3.4.0.tar.gz"
    sha256 "93d512b32a23baf4cac44ffd72ccf70732aeff7b8050fcaf6d3ec406d954baf4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/2e/6d/4508b1922b1610f6646fd95681fa1b0c092df35ec14018218f4638b7342a/importlib_metadata-4.8.2.tar.gz"
    sha256 "75bdec14c397f528724c1bfd9709d660b33a4d2e77387a3358f20b848bb5e5fb"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/28/46/d9b750ae5fb5b4fd77d169f16d87987db7d358a5eefc72be7967d4493d17/keyring-23.4.0.tar.gz"
    sha256 "88f206024295e3c6fb16bb0a60fb4bb7ec1185629dc5a729f12aa7c236d01387"
  end

  resource "keyrings.alt" do
    url "https://files.pythonhosted.org/packages/b8/a4/f9ef8a522e2f5bb273de6b5848bcb7d2fa4f0c1ea935fc8630762accb4db/keyrings.alt-4.1.0.tar.gz"
    sha256 "52ccb61d6f16c10f32f30d38cceef7811ed48e086d73e3bae86f0854352c4ab2"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/fe/4c/a4dbb4e389f75e69dbfb623462dfe0d0e652107a95481d40084830d29b37/lxml-4.6.4.tar.gz"
    sha256 "daf9bd1fee31f1c7a5928b3e1059e09a8d683ea58fb3ffc773b6c88cb8d1399c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/e3/8e/1cde9d002f48a940b9d9d38820aaf444b229450c0854bdf15305ce4a3d1a/pytz-2021.3.tar.gz"
    sha256 "acad2d8b20a1af07d4e4c9d2e9285c5ed9104354062f275f3fcd88dcef4f1326"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/e1/25/a3005eedafb34e1258458e8a4b94900a60a41a2b4e459e0e19631648a2a0/soupsieve-2.3.1.tar.gz"
    sha256 "b8d49b1cd4f037c7082a9683dfa1801aa2597fb11c3a1155b7a5b94829b4f1f9"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ae/3d/9d7576d94007eaf3bb685acbaaec66ff4cdeb0b18f1bf1f17edbeebffb0a/tabulate-0.8.9.tar.gz"
    sha256 "eb1d13f25760052e8931f2ef80aaf6045a6cceb47514db8beab24cded16f13a7"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/ce/73/99e4cc30db6b21cba6c3b3b80cffc472cc5a0feaf79c290f01f1ac460710/tzlocal-2.1.tar.gz"
    sha256 "643c97c5294aedc737780a49d9df30889321cbe1204eac2c2ec6134035a92e44"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/02/bf/0d03dbdedb83afec081fefe86cae3a2447250ef1a81ac601a9a56e785401/zipp-3.6.0.tar.gz"
    sha256 "71c644c5369f4a6e07636f0aa966270449561fcea2e3d6747b8d23efaa9d7832"
  end

  resource "pycparser" do
    on_linux do
      url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
      sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
    end
  end

  resource "cffi" do
    on_linux do
      url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
      sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
    end
  end

  resource "cryptography" do
    on_linux do
      url "https://files.pythonhosted.org/packages/60/06/d9109aba62c0b42466195e5b9b30dded26621a675b73998218070d8cc637/cryptography-36.0.0.tar.gz"
      sha256 "52f769ecb4ef39865719aedc67b4b7eae167bafa48dbc2a26dd36fa56460507f"
    end
  end

  resource "jeepney" do
    on_linux do
      url "https://files.pythonhosted.org/packages/09/0d/81744e179cf3aede2d117c20c6d5b97a62ffe16b2ca5d856e068e81c7a68/jeepney-0.7.1.tar.gz"
      sha256 "fa9e232dfa0c498bd0b8a3a73b8d8a31978304dcef0515adc859d4e096f96f4f"
    end
  end

  resource "secretstorage" do
    on_linux do
      url "https://files.pythonhosted.org/packages/cd/08/758aeb98db87547484728ea08b0292721f1b05ff9005f59b040d6203c009/SecretStorage-3.3.1.tar.gz"
      sha256 "fd666c51a6bf200643495a04abb261f83229dcb6fd8472ec393df7ffc8b6f195"
    end
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    auth_process = IO.popen "#{bin}/aws-google-auth"
    sleep 3
    Process.kill "TERM", auth_process.pid
    assert_match "AWS Region:", auth_process.read
  end
end
