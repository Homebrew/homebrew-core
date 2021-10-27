class AwsSsoUtil < Formula
  include Language::Python::Virtualenv

  desc "Smooth out the rough edges of AWS SSO (temporarily, until AWS makes it better)"
  homepage "https://github.com/benkehoe/aws-sso-util"
  url "https://files.pythonhosted.org/packages/5a/ff/28de3b5c4189d244b5bb68c0591875df0a3a47b5b860de2bb9a100f3a60b/aws-sso-util-4.25.0.tar.gz"
  sha256 "b84fb0b6bb66ee1a5797665cfeceb5d83bf9f3d6a8d8de42687dd65fc06cee8c"
  license "Apache-2.0"
  revision 1
  head "https://github.com/benkehoe/aws-sso-util.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "256739dc70865d33fad92925a0532acf5225fa748b6d54c2fd4ee9a3b1d2917b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bed223ea4b5a108ee2f68edd4b9919defc5a838650140a6ee392d18f7f5df4cb"
    sha256 cellar: :any_skip_relocation, monterey:       "792b8ad5d2b185f3df486bdb0a664b525b796120848ca5667b18a84ac64892c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c6e10121c00e11bb4451ffff6dee4abb03cdc610b910624664dc6e949210e63"
    sha256 cellar: :any_skip_relocation, catalina:       "84649f7a4b165d1625dc80a93a2faad3b289a63770d01231d1651f5d4156be2a"
    sha256 cellar: :any_skip_relocation, mojave:         "32a8269de9a8cfcd21a7b1c326f9dc05da5849401376d08f2742acc30f5d3594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6871b86922c7ff5eaf37bc78578d73b6d5ac64a5ef3c7661bcec452251ab9b7"
  end

  depends_on "rust" => :build
  depends_on "python@3.10"
  depends_on "six"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "aws-error-utils" do
    url "https://files.pythonhosted.org/packages/d6/a5/4b1213a8789314adb4a6d465fd77aec32f12bb2fedaa197525cbd4aedd32/aws-error-utils-1.2.0.tar.gz"
    sha256 "164f2a5bdd69c4cecc647d6e080c21243472c44c4d3caba15908f69d7fcfe16b"
  end

  resource "aws-sso-lib" do
    url "https://files.pythonhosted.org/packages/24/23/c178f2fae27d62307918e5825558c7513f24b2373ba7bc7c79e967f87c9c/aws-sso-lib-1.8.0.tar.gz"
    sha256 "ae12ee0cf4329593be55ba985591b337bf7c74f58f2b33d165483dc166fafbf4"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/8e/ee/231804560862872dc4528e61ec848c6f120d7fd1be0b5b5a5ea76daddd25/boto3-1.18.45.tar.gz"
    sha256 "68ee81a7ef40380a5ab973e242bbf8739d56a49f8691508c48760fb5066933e3"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/8d/0e/d39832a9718deb107c44217403633a410ed14157f56b52583b058fcac281/botocore-1.21.45.tar.gz"
    sha256 "b3a77dcc7d54a3725aa0a9b44e4a79142a013584cd0568750a9ee9ab6970538f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/f4/d7/0fa558c4fb00f15aabc6d42d365fcca7a15fcc1091cd0f5784a14f390b7f/pyrsistent-0.18.0.tar.gz"
    sha256 "773c781216f8c2900b42a7b638d5b517bb134ae1acbebe4d1e8f1f41ea60eb4b"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    cmd = "#{bin}/aws-sso-util configure profile invalid"\
          " --sso-start-url https://example.com/start --sso-region eu-west-1" \
          " --account-id 000000000000 --role-name InvalidRole" \
          " --region eu-west-1 --non-interactive"

    assert_empty shell_output "AWS_CONFIG_FILE=#{testpath}/config #{cmd}"

    assert_predicate testpath/"config", :exist?

    expected = <<~EOS

      [profile invalid]
      sso_start_url = https://example.com/start
      sso_region = eu-west-1
      sso_account_id = 000000000000
      sso_role_name = InvalidRole
      region = eu-west-1
      credential_process = aws-sso-util credential-process --profile invalid
    EOS

    assert_equal expected, (testpath/"config").read
  end
end
