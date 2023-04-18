class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/0e/63/c2aed27057343d776c95b2d95e1580a287fdc2ceb43e1ac64ae2d7bf32d5/gimme%20aws%20creds-2.5.0.tar.gz"
  sha256 "706644a0c67dbaadd4b45b5d1f46a2f226bca3a6686e8df5eb79e13396a275d7"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "5c78a4ff301aae73211c5baaab639b72640a93a8db85f064fa7c28d6f2c0c38b"
    sha256 cellar: :any,                 arm64_monterey: "efafa2b2d5d2f56068ff2aeb39125fc0c009bb5adf14d657c5d7d9294f3a8a5a"
    sha256 cellar: :any,                 arm64_big_sur:  "7b4e21c4aa5cf189c03e32198e9e0eb9443b4498cb1c7dfcb80517374271ba89"
    sha256 cellar: :any,                 ventura:        "44782591633ce62bad8f8053996c0710e78d99962d36d41dbb626ee9917b96af"
    sha256 cellar: :any,                 monterey:       "393aaf2aaef43893a1e856f0f69eb27a46dc8be29f27c8437b96f6dc86704eec"
    sha256 cellar: :any,                 big_sur:        "a86cf4dc28a4ca7418377129d61c61bb07fac0a39eb927f46ee05f085044ec64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4438d7d15e6f271e8a34c1921305b06d277bec53fc5777ed8a353881401022c"
  end

  depends_on "rust" => :build
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  # Extra package resources are set for platform-specific dependencies in
  # pypi_formula_mappings.json, since the output of `bump-formula-pr` and
  # `update-python-resources` is impacted by whether command is run on macOS
  # or Linux. Remove if Homebrew logic is enhanced to handle this. Also,
  # occasionally check if any of these Python dependencies are no longer used.
  #
  # Linux: `jeepney`, `SecretStorage`
  # - gimme-aws-creds
  #   ├── keyring
  #       ├── jeepney
  #       └── secretstorage
  #
  # macOS: `pyobjc-framework-localauthentication`, ...
  # - gimme-aws-creds
  #   ├── ctap-keyring-device
  #       └── pyobjc-framework-localauthentication
  #           ├── pyobjc-core
  #           ├── ...

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/75/f8/de84282681c5a8307f3fff67b64641627b2652752d49d9222b77400d02b8/beautifulsoup4-4.11.2.tar.gz"
    sha256 "bc4bdda6717de5a2987436fb8d72f45dc90dd856bdfd512a1314ce90349a0106"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/8d/59/72ed66c45aacdc1339423ed2f4e350594ed233deabac726dbcd69b4d847f/boto3-1.26.67.tar.gz"
    sha256 "c2e21ac64370fee1f3dccd97b4767e89d046c45c00faec27c36405618e34c7e5"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/fb/e3/5557a3301221e8c984344acce43af61ed2ff99cf39aefa4305e400ef3620/botocore-1.29.67.tar.gz"
    sha256 "0ccec4a906b6b8c7bb6bc5226509059ee9ed94d3cf1014487ef5b8e56801e6a3"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/b1/83/fa54eee6643ffb30ab5a5bebdb523c697363658e46b85729e3d587a3765e/configparser-3.8.1.tar.gz"
    sha256 "bc37850f0cc42a1725a796ef7d92690651bf1af37d744cc63161dac62cabee17"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/6a/f5/a729774d087e50fffd1438b3877a91e9281294f985bda0fd15bf99016c78/cryptography-39.0.1.tar.gz"
    sha256 "d1f6198ee6d9148405e49887803907fe8962a23e6c6f83ea7d98f1c0de375695"
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
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/90/07/6397ad02d31bddf1841c9ad3ec30a693a3ff208e09c2ef45c9a8a5f85156/importlib_metadata-6.0.0.tar.gz"
    sha256 "e354bedeb60efa6affdcc8ae121b73544a7aa74156d047311948f6d711cd378d"
  end

  resource "jaraco.classes" do
    url "https://files.pythonhosted.org/packages/bf/02/a956c9bfd2dfe60b30c065ed8e28df7fcf72b292b861dca97e951c145ef6/jaraco.classes-3.2.3.tar.gz"
    sha256 "89559fa5c1d3c34eff6f631ad80bb21f378dbcbb35dd161fd2c6b93f5be2f98a"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/55/fe/282f4c205add8e8bb3a1635cbbac59d6def2e0891b145aa553a0e40dd2d0/keyring-23.13.1.tar.gz"
    sha256 "ba2e15a9b35e21908d0aaf4e0a47acc52d6ae33444df0da2b49d41a46ef6d678"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/13/b3/397aa9668da8b1f0c307bc474608653d46122ae0563d1d32f60e24fa0cbd/more-itertools-9.0.0.tar.gz"
    sha256 "5a6257e40878ef0520b1803990e3e22303a41b5714006c32a3fd8304b26ea1ab"
  end

  resource "okta" do
    url "https://files.pythonhosted.org/packages/e8/2a/1c1bae7ed0b429cfe04caaff4ec06383669b651b315328b15f87ab67d347/okta-0.0.4.tar.gz"
    sha256 "53e792c68d3684ff4140b4cb1c02af3821090368f8110fde54c0bdb638449332"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/1e/20/75b43cd85d8676d15f7d3876e8b64415bfd7b7f937710f9966738723daf3/pyobjc-core-9.0.1.tar.gz"
    sha256 "5ce1510bb0bdff527c597079a42b2e13a19b7592e76850be7960a2775b59c929"
  end

  resource "pyobjc-framework-Cocoa" do
    url "https://files.pythonhosted.org/packages/b5/35/da77d26b9b6ee97fede0a9364273aaa7970fea7947d15c0e28efd345db0e/pyobjc-framework-Cocoa-9.0.1.tar.gz"
    sha256 "a8b53b3426f94307a58e2f8214dc1094c19afa9dcb96f21be12f937d968b2df3"
  end

  resource "pyobjc-framework-LocalAuthentication" do
    url "https://files.pythonhosted.org/packages/7e/9a/9f61d91b030365bfc6e4b0fe36ac29f9069de5d59569e84b1a75965f9833/pyobjc-framework-LocalAuthentication-9.0.1.tar.gz"
    sha256 "f440325d33b4ce87200f876940c6d89c91a80bdbfc4926d174a5f11cd664c3dd"
  end

  resource "pyobjc-framework-Security" do
    url "https://files.pythonhosted.org/packages/64/fa/a5b51b4c7fb86365cffaae11474d360a8d68910098b618a76a206b00938c/pyobjc-framework-Security-9.0.1.tar.gz"
    sha256 "d2093debe7467d85dd7ecef130d592abe6c13ffdbaf943d6624bae4a081046e0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "SecretStorage" do
    url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/f3/03/bac179d539362319b4779a00764e95f7542f4920084163db6b0fd4742d38/soupsieve-2.3.2.post1.tar.gz"
    sha256 "fc53893b3da2c33de295667a0e19f078c14bf86544af307354de5fcf12a3f30d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/d1/2f/ba544a8a6ad5ad9dcec1b00f536bb9fb078f5f50d1a1408876de18a9151b/zipp-3.13.0.tar.gz"
    sha256 "23f70e964bc11a34cef175bc90ba2914e1e4545ea1e3e2f67c079671883f9cb6"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    res = resources.to_set(&:name)
    if OS.mac?
      res -= ["jeepney", "SecretStorage"]
    else
      res.reject! { |r| r.start_with? "pyobjc" }
    end
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
