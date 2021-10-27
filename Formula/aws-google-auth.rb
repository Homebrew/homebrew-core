class AwsGoogleAuth < Formula
  include Language::Python::Virtualenv

  desc "Acquire AWS credentials using Google Apps"
  homepage "https://github.com/cevoaustralia/aws-google-auth"
  url "https://files.pythonhosted.org/packages/17/42/b466b9376f88f27d4d251b2e61194879a840b7be0c3a6808bc20381b2d5e/aws-google-auth-0.0.37.tar.gz"
  sha256 "0cc76e88ac188a26a484faffb21f1c7f31c0c56932aa30e6772e17245d0eb7cc"
  license "MIT"
  revision 4
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
  depends_on "python@3.9"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/6b/c3/d31704ae558dcca862e4ee8e8388f357af6c9d9acb0cad4ba0fbbd350d9a/beautifulsoup4-4.9.3.tar.gz"
    sha256 "84729e322ad1d5b4d25f805bfa05b902dd96450f43842c4e99067d5e1369eb25"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/31/4c/879d528f74a3288a03cc664c5e1618a0f71e835a731a7c2594165823c4a3/boto3-1.17.104.tar.gz"
    sha256 "055f9dc07f95f202a4dc25196a3a9f1e2f137171ee364cf980e4673de75fb529"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/2b/53/bf0f05a3981ed0c366b25777c72136d4d6f397c104d8568b7899a640a41a/botocore-1.20.104.tar.gz"
    sha256 "23aa3238c004319f78423eb8cbba2813b62ee64d0e3bab04e0a00e067f99542a"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/c9/9c/c1ac39b3c72a70e93479cb4b7f1123f693293c5e4c40fdb3e1242f740665/configparser-5.0.2.tar.gz"
    sha256 "85d5de102cfe6d14a5172676f09d19c465ce63d6019cf0a4ef13385fc535e828"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/14/ec/6ee2168387ce0154632f856d5cc5592328e9cf93127c5c9aeca92c8c16cb/filelock-3.0.12.tar.gz"
    sha256 "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/0e/75/92eed8e2ae8cd78f03c8ab9faf26e561482f3453a6f271a81e792178dd54/importlib_metadata-4.6.0.tar.gz"
    sha256 "4a5611fea3768d3d967c447ab4e93f567d95db92225b43b7b238dbfb855d70bb"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/b0/b5/b27458e1d2adf2a11c6e95c67ac63f828e96fe7e166132e5dacbe03e88c0/keyring-23.0.1.tar.gz"
    sha256 "045703609dd3fccfcdb27da201684278823b72af515aedec1a8515719a038cb8"
  end

  resource "keyrings.alt" do
    url "https://files.pythonhosted.org/packages/bb/d9/fb7ec376d5c285b0178cc59e36349563480d1f6eed775fb71a49b86afb73/keyrings.alt-4.0.2.tar.gz"
    sha256 "cc475635099d6edd7e475c5a479e5b4da5e811a3af04495a1e9ada488d16fe25"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e5/21/a2e4517e3d216f0051687eea3d3317557bde68736f038a3b105ac3809247/lxml-4.6.3.tar.gz"
    sha256 "39b78571b3b30645ac77b95f7c69d1bffc4cf8c3b157c435a34da72e78c82468"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/27/90/f467e516a845cf378d85f0a51913c642e31e2570eb64b352c4dc4c6cbfc7/s3transfer-0.4.2.tar.gz"
    sha256 "cb022f4b16551edebbb31a377d3f09600dbada7363d8c5db7976e7f47732e1b2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/c8/3f/e71d92e90771ac2d69986aa0e81cf0dfda6271e8483698f4847b861dd449/soupsieve-2.2.1.tar.gz"
    sha256 "052774848f448cf19c7e959adf5566904d525f33a3f8b6ba6f6f8f26ec7de0cc"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/ce/73/99e4cc30db6b21cba6c3b3b80cffc472cc5a0feaf79c290f01f1ac460710/tzlocal-2.1.tar.gz"
    sha256 "643c97c5294aedc737780a49d9df30889321cbe1204eac2c2ec6134035a92e44"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/38/f9/4fa6df2753ded1bcc1ce2fdd8046f78bd240ff7647f5c9bcf547c0df77e3/zipp-3.4.1.tar.gz"
    sha256 "3607921face881ba3e026887d8150cca609d517579abe052ac81fc5aeffdbd76"
  end

  resource "pycparser" do
    on_linux do
      url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz#sha256=a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
      sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
    end
  end

  resource "cffi" do
    on_linux do
      url "https://files.pythonhosted.org/packages/2d/bf/960e5a422db3ac1a5e612cb35ca436c3fc985ed4b7ed13a1b4879006f450/cffi-1.13.2.tar.gz#sha256=599a1e8ff057ac530c9ad1778293c665cb81a791421f46922d80a86473c13346"
      sha256 "599a1e8ff057ac530c9ad1778293c665cb81a791421f46922d80a86473c13346"
    end
  end

  resource "cryptography" do
    on_linux do
      url "https://files.pythonhosted.org/packages/fa/2d/2154d8cb773064570f48ec0b60258a4522490fcb115a6c7c9423482ca993/cryptography-3.4.6.tar.gz"
      sha256 "2d32223e5b0ee02943f32b19245b61a62db83a882f0e76cc564e1cec60d48f87"
    end
  end

  resource "jeepney" do
    on_linux do
      url "https://files.pythonhosted.org/packages/74/24/9b720cc6b2a73c908896a0ed64cb49780dcfbf4964e23a725aa6323f4452/jeepney-0.4.3.tar.gz#sha256=3479b861cc2b6407de5188695fa1a8d57e5072d7059322469b62628869b8e36e"
      sha256 "3479b861cc2b6407de5188695fa1a8d57e5072d7059322469b62628869b8e36e"
    end
  end

  resource "secretstorage" do
    on_linux do
      url "https://files.pythonhosted.org/packages/a6/89/df343dbc2957a317127e7ff2983230dc5336273be34f2e1911519d85aeb5/SecretStorage-3.1.1.tar.gz#sha256=20c797ae48a4419f66f8d28fc221623f11fc45b6828f96bdb1ad9990acb59f92"
      sha256 "20c797ae48a4419f66f8d28fc221623f11fc45b6828f96bdb1ad9990acb59f92"
    end
  end

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra
    virtualenv_install_with_resources
  end

  test do
    auth_process = IO.popen "#{bin}/aws-google-auth"
    sleep 3
    Process.kill "TERM", auth_process.pid
    assert_match "AWS Region:", auth_process.read
  end
end
