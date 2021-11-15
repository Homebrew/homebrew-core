class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/d9/c1/3b744022fe388e95d9f7011c26a1f5d2a844c1a49e385403350f3e9d0815/gimme%20aws%20creds-2.4.3.tar.gz"
  sha256 "4efd68f3e4f74672b4dc69595307a2abe34600f9d91ce18f202b069407fd0b69"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e821576279fb0e459ef0e85cdc0412912f5305d14ab5791396885c1e8c5210cb"
    sha256 cellar: :any,                 arm64_big_sur:  "79db99c0fd02f82565098e7a8919a0d30a7941f45a760b6df8bfdc99ae870a83"
    sha256 cellar: :any,                 monterey:       "fde3e4cdb6aad3a994d2d65a4ff42cc87685b3425755371db113731824ef2951"
    sha256 cellar: :any,                 big_sur:        "ef2a8e825e256d488ce78ad49da4e7c1c8b0018acd5394f61c782326db0225f6"
    sha256 cellar: :any,                 catalina:       "d91906e9ffb1fe3354e62ba7de1b2309d8f6dc0a70c4ae63c86609ba3fc3c455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d66bb53ac6aafbf7c00e612101bf589763a41e56be1c5766c415ac87cd0db8ff"
  end

  depends_on "rust" => :build

  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "libffi"

  on_macos do
    resource "pyobjc-framework" do
      url "https://github.com/ronaldoussoren/pyobjc/archive/62fac9c358846371be308bb0b103a857bba5136f.tar.gz"
      sha256 "f38ff3251c008975a3fbc8184952824436bf47c6eba0de40f181a7fe14914066"
    end
  end

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/a1/69/daeee6d8f22c997e522cdbeb59641c4d31ab120aba0f2c799500f7456b7e/beautifulsoup4-4.10.0.tar.gz"
    sha256 "c23ad23c521d818955a4151a67d81580319d4bf548d3d49f4223ae041ff98891"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ec/45/d12f9c09b5c4dad8bcb098dfae5e9e1253ed6408efbbd9a3e60bff55b824/boto3-1.19.2.tar.gz"
    sha256 "11a6035060230e92327d4f10fef6bc44188b2cd68504012bc25ed62ac31d670b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/0d/95/f2e74e4a91994d9ebe45746f75a8c5cafd723a88270a9772d8d66e1a8ba1/botocore-1.22.2.tar.gz"
    sha256 "011360e79a4b843aa6591573cfa61e8eddc99b91adab1dfdb9a2b7f2c8511193"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/b1/83/fa54eee6643ffb30ab5a5bebdb523c697363658e46b85729e3d587a3765e/configparser-3.8.1.tar.gz"
    sha256 "bc37850f0cc42a1725a796ef7d92690651bf1af37d744cc63161dac62cabee17"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/91/90b8d4cd611ac2aa526290ae4b4285aa5ea57ee191c63c2f3d04170d7683/cryptography-35.0.0.tar.gz"
    sha256 "9933f28f70d0517686bd7de36166dda42094eac49415459d9bdf5e7df3e0086d"
  end

  resource "ctap-keyring-device" do
    url "https://files.pythonhosted.org/packages/c4/c5/5c4ce510d457679c8886229ddbdc2a84969d63e50fe9fb09d6975d8e500e/ctap-keyring-device-1.0.6.tar.gz"
    sha256 "a44264bb3d30c4ab763e4a3098b136602f873d86b666210d2bb1405b5e0473f6"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/39/dc/0f7f17a1291dabe682a9a296e66a1b130d1d7dcf4ad9ffeb70326e87595c/fido2-0.9.2.tar.gz"
    sha256 "f491c47bb2d74fa157f9d127a1cbb2753a15939a21e78ba8b0bd323d7d101c61"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/f0/70/ca3dd67cdd368b957e73a8156f7e1a10339f9813e314cb8b4549526070da/importlib_metadata-4.8.1.tar.gz"
    sha256 "f284b3e11256ad1e5d03ab86bb2ccd6f5339688ff17a4d797a0fe7df326f23b1"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/cc/24/c5402ba0c6380cc058980e2b73f0597ab6875692f185054a94244b7161ab/keyring-23.2.1.tar.gz"
    sha256 "6334aee6073db2fb1f30892697b1730105b5e9a77ce7e61fca6b435225493efe"
  end

  resource "okta" do
    url "https://files.pythonhosted.org/packages/e8/2a/1c1bae7ed0b429cfe04caaff4ec06383669b651b315328b15f87ab67d347/okta-0.0.4.tar.gz"
    sha256 "53e792c68d3684ff4140b4cb1c02af3821090368f8110fde54c0bdb638449332"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/c8/3f/e71d92e90771ac2d69986aa0e81cf0dfda6271e8483698f4847b861dd449/soupsieve-2.2.1.tar.gz"
    sha256 "052774848f448cf19c7e959adf5566904d525f33a3f8b6ba6f6f8f26ec7de0cc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/02/bf/0d03dbdedb83afec081fefe86cae3a2447250ef1a81ac601a9a56e785401/zipp-3.6.0.tar.gz"
    sha256 "71c644c5369f4a6e07636f0aa966270449561fcea2e3d6747b8d23efaa9d7832"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.10"].opt_bin/"python3")

    if OS.mac?
      resource("pyobjc-framework").stage do
        %w[pyobjc-core
           pyobjc-framework-Cocoa
           pyobjc-framework-LocalAuthentication
           pyobjc-framework-Security].each do |name|
          Dir.chdir(name) do
            system Formula["python@3.10"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
          end
        end
      end
    end

    res = resources.map(&:name).to_set - ["pyobjc-framework"]
    res.each do |r|
      venv.pip_install resource(r)
    end
    venv.pip_install_and_link buildpath
  end

  test do
    # Workaround gimme-aws-creds bug which runs action-configure twice when config file is missing.
    config_file = Pathname(".okta_aws_login_config")
    touch(config_file)

    assert_match "Okta Configuration Profile Name",
      pipe_output("#{bin}/gimme-aws-creds --profile TESTPROFILE --action-configure 2>&1",
                  "https://something.oktapreview.com\n\n\n\n\n\n\n\n\n\n\n")
    assert_match "", config_file.read

    assert_match version.to_s, shell_output("#{bin}/gimme-aws-creds --version")
  end
end
