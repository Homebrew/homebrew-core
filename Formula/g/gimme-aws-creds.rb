class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/69/76/a6c0e4d65438ef3b95099c919388fbdc617d89afb40e024ec2c22665e3d5/gimme_aws_creds-2.7.2.tar.gz"
  sha256 "71526a98bd249bb3880cb2813817623d29ea880eaf260bbb5d1d366ccfae9474"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d94abae7e37e984acc15a9bff2df464e07744eb01ba4ffb195bc8cee9df01364"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50ce43b52e7ab1387f8493fe6fdf70f8ce8f141d4ffacbdcd46cb6806d41fd73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0f8faaf9e290c1c382de28623a3609fc7e3a2756b5dfcad904acf6e47ab2d43"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea77f7587f2fed8b3735108a6f558c5b65dedbc23fce437f3180cb0359371d56"
    sha256 cellar: :any_skip_relocation, ventura:        "400f99d0d6f0c9b86724d8d0aa991f9739ebb13c5aec73b104cba8a1575fa9c1"
    sha256 cellar: :any_skip_relocation, monterey:       "32547ef0ed33ec72417e3b7eb258697c25a82d900137b5939526f7c5806b1283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31c49ce5abfb6870407ff4d8a027f6940f388840fdb91baadb9552b88b042d58"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  # Extra package resources are set for platform-specific dependencies in
  # pypi_formula_mappings.json, since the output of `bump-formula-pr` and
  # `update-python-resources` is impacted by whether command is run on macOS
  # or Linux. Remove if Homebrew logic is enhanced to handle this. Also,
  # occasionally check if any of these Python dependencies are no longer used.
  #
  # macOS: `pyobjc-framework-localauthentication`, ...
  # - gimme-aws-creds
  #   ├── ctap-keyring-device
  #       └── pyobjc-framework-localauthentication
  #           ├── pyobjc-core
  #           ├── ...

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/46/6d/8f361c95d4f948dae469a3072cf998f62300ca3bc1a311c1c029a2793313/boto3-1.34.83.tar.gz"
    sha256 "9733ce811bd82feab506ad9309e375a79cabe8c6149061971c17754ce8997551"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/0c/b8/6d1ec4802de76d21851784ca2b1d26575f193c31ebd194a196d08dac0d0d/botocore-1.34.83.tar.gz"
    sha256 "0f302aa76283d4df62b4fbb6d3d20115c1a8957fc02171257fc93904d69d5636"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
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

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/18/ec/cc0afdcd7538d4942a6b78f858139120a8c7999e554004080ed312e43886/keyring-25.1.0.tar.gz"
    sha256 "7230ea690525133f6ad536a9b5def74a4bd52642abe594761028fc044d7c7893"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/df/ad/7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4/more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "okta" do
    url "https://files.pythonhosted.org/packages/e8/2a/1c1bae7ed0b429cfe04caaff4ec06383669b651b315328b15f87ab67d347/okta-0.0.4.tar.gz"
    sha256 "53e792c68d3684ff4140b4cb1c02af3821090368f8110fde54c0bdb638449332"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/30/72/8259b2bccfe4673330cea843ab23f86858a419d8f1493f66d413a76c7e3b/PyJWT-2.8.0.tar.gz"
    sha256 "57e28d156e3d5c10088e0c68abb90bfac3df82b40a71bd0daa20c65ccd5c23de"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/24/ac/61c58e65780c6ba0523997d236fac99e38e5ddfabfd5b500409f8239a257/pyobjc-core-10.2.tar.gz"
    sha256 "0153206e15d0e0d7abd53ee8a7fbaf5606602a032e177a028fc8589516a8771c"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/b0/c0/7eb30628e1a60c8b700f0b15280417c754eda9f186d05d47f4cac6f4e1a7/pyobjc-framework-Cocoa-10.2.tar.gz"
    sha256 "6383141379636b13855dca1b39c032752862b829f93a49d7ddb35046abfdc035"
  end

  resource "pyobjc-framework-localauthentication" do
    url "https://files.pythonhosted.org/packages/ae/dd/15f5d505f097e655824d8d88d93f67d0bbb40a3c589c1e2f9eff71683344/pyobjc-framework-LocalAuthentication-10.2.tar.gz"
    sha256 "26e899e8b4a90632958eb323abbc06d7b55c64d894d4530a9cc92d49dc115a7e"
  end

  resource "pyobjc-framework-security" do
    url "https://files.pythonhosted.org/packages/8f/3c/f251e7143a44b62f4e87f0cb7b42d30c8dbef1be0de4db45a4bdcfb4ac71/pyobjc-framework-Security-10.2.tar.gz"
    sha256 "20ec8ebb41506037d54b40606590b90f66a89adceeddd9a40674b0c7ea7c8c82"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/83/bc/fb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571/s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/0c/39/64487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08/urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources.reject { |r| r.name.start_with?("pyobjc") && OS.linux? }
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
