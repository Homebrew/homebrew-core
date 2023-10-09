class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/69/76/a6c0e4d65438ef3b95099c919388fbdc617d89afb40e024ec2c22665e3d5/gimme_aws_creds-2.7.2.tar.gz"
  sha256 "71526a98bd249bb3880cb2813817623d29ea880eaf260bbb5d1d366ccfae9474"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39f498026ceeb7331b64f696ca4a62337dba08d97a089f2b68c796a8f3baf689"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "114de96f48a341719b23ab8ba09332b41142ce5039ab09653171a26305fe422d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a95c1c1a4d61493df38c3fcba2068acccfba31964efcc24bc2ea7b77020d99d"
    sha256 cellar: :any_skip_relocation, sonoma:         "8539e0f5bbecbc2d9d49c7768f771b7a4e8bece5b3ae6f94846dd3fceac66daa"
    sha256 cellar: :any_skip_relocation, ventura:        "30d1e2ec5da8f538f9ce79cb918767da64b72628c2e8bdd755ca81cf6202c3ce"
    sha256 cellar: :any_skip_relocation, monterey:       "791d0c4daf037a0756cd6548cd53ac5e254d148b01e04eee386601564f368a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a45ec30191be7865f64eea9639fa0705189cdebc8716cf0de9f1ef0a2ed22310"
  end

  depends_on "cffi"
  depends_on "keyring"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.11"
  depends_on "six"

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
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/42/56/633b5f5b930732282e8dfb05c02a3d19394d41f4e60abfe85d26497e8036/boto3-1.28.61.tar.gz"
    sha256 "7a539aaf00eb45aea1ae857ef5d05e67def24fc07af4cb36c202fa45f8f30590"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/05/2e/9cb8adca433af2bb6240514448b35fa797c881975ea752242294d6e0b79f/botocore-1.31.61.tar.gz"
    sha256 "39b059603f0e92a26599eecc7fe9b141f13eb412c964786ca3a7df5375928c87"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
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
    url "https://files.pythonhosted.org/packages/a4/ca/9f5f8aab90b7b9d006ee40e08dcfa1a5f74ab10b4504951bca97379016aa/pyobjc-core-10.0.tar.gz"
    sha256 "3dd0a7b3acd7e0b8ffd3f5331b29a3aaebe79a03323e61efeece38627a6020b3"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/50/86/afa561caab8883b2ce155fd0067f6265bf10780a4db08bff3d76714c1dc4/pyobjc-framework-Cocoa-10.0.tar.gz"
    sha256 "723421eff4f59e4ca9a9bb8ec6dafbc0f778141236fa85a49fdd86732d58a74c"
  end

  resource "pyobjc-framework-localauthentication" do
    url "https://files.pythonhosted.org/packages/45/48/0cc579e84e409f13876821f1756ad28b9efc463a9844a039d5034b7f9aa6/pyobjc-framework-LocalAuthentication-10.0.tar.gz"
    sha256 "c7ca39512babcd08464b12586908d895efe3477289325cd12ab14768a194ed16"
  end

  resource "pyobjc-framework-security" do
    url "https://files.pythonhosted.org/packages/8a/65/236ae685e6e367ee396c526e39e14a72e19b2ac20a799527941be9c3add9/pyobjc-framework-Security-10.0.tar.gz"
    sha256 "89837b93aaae053d80430da6a3dbd6430ca9d889aa43c3d53ed4ce81afa99462"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/dd/19/9e5c8b813a8bddbfb035fa2b0c29077836ae7c4def1a55ae4632167b3511/urllib3-1.26.17.tar.gz"
    sha256 "24d6a242c28d29af46c3fae832c36db3bbebcc533dd1bb549172cd739c82df21"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources.reject { |r| r.name.start_with?("pyobjc") && OS.linux? }
    venv.pip_install_and_link buildpath

    # we depend on virtualenv, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    paths = %w[keyring].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")
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
