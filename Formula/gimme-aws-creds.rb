class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/d9/c1/3b744022fe388e95d9f7011c26a1f5d2a844c1a49e385403350f3e9d0815/gimme%20aws%20creds-2.4.3.tar.gz"
  sha256 "4efd68f3e4f74672b4dc69595307a2abe34600f9d91ce18f202b069407fd0b69"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e906f63ae3668981e1fec3afca1a4b2d8b875fb4cc4dcad6f0135c5ce84b16fb"
    sha256 cellar: :any,                 big_sur:       "400eb67cf04cff7d0c4eac4a4dc1f8d6e0853d8c03390e455d4af6e3dd5b8bd7"
    sha256 cellar: :any,                 catalina:      "c53ee6d613ddd45e3305607706d4b0e9c9d370415aef166c6570f57ad24b1990"
    sha256 cellar: :any,                 mojave:        "f8c5d2d4a68df930855edbc57edb5ea16cdf48db02e587b49fc878e67170f2f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d13b0f33714a1a3f39589e5bdb2cf8fb05b343ec2a176a1d34ac0c22469b3772"
  end

  depends_on "rust" => :build
  depends_on "python@3.9"

  uses_from_macos "libffi"

  on_macos do
    resource "pyobjc-core" do
      url "https://files.pythonhosted.org/packages/50/eb/a358e36731f5cb3b824ca27d2260f7f6acbd0d1f63c971ca83b4627d9ec6/pyobjc-core-7.3.tar.gz"
      sha256 "5081aedf8bb40aac1a8ad95adac9e44e148a882686ded614adf46bb67fd67574"
    end

    resource "pyobjc-framework-Cocoa" do
      url "https://files.pythonhosted.org/packages/72/b8/ff4fad9271931746a38c0a253b26054d7a94720353d9ab8b9dd847f47e1f/pyobjc-framework-Cocoa-7.3.tar.gz"
      sha256 "b18d05e7a795a3455ad191c3e43d6bfa673c2a4fd480bb1ccf57191051b80b7e"
    end

    resource "pyobjc-framework-LocalAuthentication" do
      url "https://files.pythonhosted.org/packages/0e/d3/e55fb2d11f88e9445f825298765a7c72d2145412935573c91b191dbc8dfd/pyobjc-framework-LocalAuthentication-7.3.tar.gz"
      sha256 "0c7ac94f90e3e5e1797980dca08548f5e7ce38ba1578d10b45dd2b611c41183a"
    end

    resource "pyobjc-framework-Security" do
      url "https://files.pythonhosted.org/packages/b4/04/2ce0be4968fb0e6ad8bda15076e40cbce8c5b09628ef6a999eba041bc99b/pyobjc-framework-Security-7.3.tar.gz"
      sha256 "4109ab15faf2dcf89646330a4f0a6584410d7134418fae0814858cab4ab76347"
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
    url "https://files.pythonhosted.org/packages/e6/c5/888048a93a71b53cf320925ada2d2a7eaab92229824b13677e37f02ef4e7/boto3-1.18.40.tar.gz"
    sha256 "f04a2d07b2c25135f302a40819be02ef74599829fab0f16126da4f2ff7df91f9"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/b7/88/fe628b486c120cef17e2796e4a67636039ac8a18325a1106755aa3cdab5a/botocore-1.21.40.tar.gz"
    sha256 "95efb127e9149f7a6b12b116cb1e65c11e36bf6d588ac877b2b51a3c9bbcf22a"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2e/92/87bb61538d7e60da8a7ec247dc048f7671afe17016cd0008b3b710012804/cffi-1.14.6.tar.gz"
    sha256 "c9a875ce9d7fe32887784274dd533c57909b7b1dcadcc128a2ac21331a9765dd"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/4e/2af0238001648ded297fb54ceb425ca26faa15b341b4fac5371d3938666e/charset-normalizer-2.0.4.tar.gz"
    sha256 "f23667ebe1084be45f6ae0538e4a5a865206544097e4e8bbcacf42cd02a348f3"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/b1/83/fa54eee6643ffb30ab5a5bebdb523c697363658e46b85729e3d587a3765e/configparser-3.8.1.tar.gz"
    sha256 "bc37850f0cc42a1725a796ef7d92690651bf1af37d744cc63161dac62cabee17"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/cc/98/8a258ab4787e6f835d350639792527d2eb7946ff9fc0caca9c3f4cf5dcfe/cryptography-3.4.8.tar.gz"
    sha256 "94cc5ed4ceaefcbe5bf38c8fba6a21fc1d365bb8fb826ea1688e3370b2e24a1c"
  end

  resource "ctap-keyring-device" do
    url "https://files.pythonhosted.org/packages/c4/c5/5c4ce510d457679c8886229ddbdc2a84969d63e50fe9fb09d6975d8e500e/ctap-keyring-device-1.0.6.tar.gz"
    sha256 "a44264bb3d30c4ab763e4a3098b136602f873d86b666210d2bb1405b5e0473f6"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/80/c3/5077ee98edd23ee00b9f5f889fd65e8dd8dbe7717d663d3b5137e31f07e6/fido2-0.9.1.tar.gz"
    sha256 "8680ee25238e2307596eb3900a0f8c0d9cc91189146ed8039544f1a3a69dfe6e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
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

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/c8/3f/e71d92e90771ac2d69986aa0e81cf0dfda6271e8483698f4847b861dd449/soupsieve-2.2.1.tar.gz"
    sha256 "052774848f448cf19c7e959adf5566904d525f33a3f8b6ba6f6f8f26ec7de0cc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3a/9f/1d4b62cbe8d222539a84089eeab603d8e45ee1f897803a0ae0860400d6e7/zipp-3.5.0.tar.gz"
    sha256 "f5812b1e007e48cff63449a5e9f4e7ebea716b4111f9c4f9a645f91d579bf0c4"
  end

  def install
    virtualenv_install_with_resources
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
