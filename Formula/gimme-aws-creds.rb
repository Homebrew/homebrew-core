class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/d9/c1/3b744022fe388e95d9f7011c26a1f5d2a844c1a49e385403350f3e9d0815/gimme%20aws%20creds-2.4.3.tar.gz"
  sha256 "4efd68f3e4f74672b4dc69595307a2abe34600f9d91ce18f202b069407fd0b69"
  license "Apache-2.0"
  revision 2

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
    url "https://files.pythonhosted.org/packages/63/81/22ecf9fd7a283ee3936c23552f370dfd261302d55b24dceabc25f9ab4254/boto3-1.20.26.tar.gz"
    sha256 "9c13f5c8fadf29088fac5feab849399169b6e8438c3b9a2310abdb7e5013ab65"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/d0/c0/0f8026e7d0bbb633ab048cdd121aa4446e30c39aada083af4d724be0822a/botocore-1.23.26.tar.gz"
    sha256 "0a933e3af6ecf79666beb2dfcb52a60f8ad1fee7df507f2a9202fe26fe569483"
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
    url "https://files.pythonhosted.org/packages/68/e4/e014e7360fc6d1ccc507fe0b563b4646d00e0d4f9beec4975026dd15850b/charset-normalizer-2.0.9.tar.gz"
    sha256 "b0b883e8e874edfdece9c28f314e3dd5badf067342e42fb162203335ae61aa2c"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/b1/83/fa54eee6643ffb30ab5a5bebdb523c697363658e46b85729e3d587a3765e/configparser-3.8.1.tar.gz"
    sha256 "bc37850f0cc42a1725a796ef7d92690651bf1af37d744cc63161dac62cabee17"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f9/4b/1cf8e281f7ae4046a59e5e39dd7471d46db9f61bb564fddbff9084c4334f/cryptography-36.0.1.tar.gz"
    sha256 "53e5c1dc3d7a953de055d77bef2ff607ceef7a2aac0353b5d630ab67f7423638"
  end

  resource "ctap-keyring-device" do
    url "https://files.pythonhosted.org/packages/c4/c5/5c4ce510d457679c8886229ddbdc2a84969d63e50fe9fb09d6975d8e500e/ctap-keyring-device-1.0.6.tar.gz"
    sha256 "a44264bb3d30c4ab763e4a3098b136602f873d86b666210d2bb1405b5e0473f6"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/74/6e/58e1bb40a284291ab483d00831c5b91fe14d498a3ae7c658f3c588658e4b/fido2-0.9.3.tar.gz"
    sha256 "b45e89a6109cfcb7f1bb513776aa2d6408e95c4822f83a253918b944083466ec"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/50/05/fef7fbb7e781e0632ebba4e6e37bcc88b9615e76338850dc31435091ddc0/importlib_metadata-4.10.0.tar.gz"
    sha256 "92a8b58ce734b2a4494878e0ecf7d79ccd7a128b5fc6014c401e0b61f006f0f6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/28/46/d9b750ae5fb5b4fd77d169f16d87987db7d358a5eefc72be7967d4493d17/keyring-23.4.0.tar.gz"
    sha256 "88f206024295e3c6fb16bb0a60fb4bb7ec1185629dc5a729f12aa7c236d01387"
  end

  resource "okta" do
    url "https://files.pythonhosted.org/packages/e8/2a/1c1bae7ed0b429cfe04caaff4ec06383669b651b315328b15f87ab67d347/okta-0.0.4.tar.gz"
    sha256 "53e792c68d3684ff4140b4cb1c02af3821090368f8110fde54c0bdb638449332"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
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
    url "https://files.pythonhosted.org/packages/e1/25/a3005eedafb34e1258458e8a4b94900a60a41a2b4e459e0e19631648a2a0/soupsieve-2.3.1.tar.gz"
    sha256 "b8d49b1cd4f037c7082a9683dfa1801aa2597fb11c3a1155b7a5b94829b4f1f9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/94/64/3115548d41cb001378099cb4fc6a6889c64ef43ac1b0e68c9e80b55884fa/zipp-3.7.0.tar.gz"
    sha256 "9f50f446828eb9d45b267433fd3e9da8d801f614129124863f9c51ebceafb87d"
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
