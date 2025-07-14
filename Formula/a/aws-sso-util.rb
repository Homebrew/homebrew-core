class AwsSsoUtil < Formula
  include Language::Python::Virtualenv

  desc "Smooth out the rough edges of AWS SSO (temporarily, until AWS makes it better)"
  homepage "https://github.com/benkehoe/aws-sso-util"
  url "https://files.pythonhosted.org/packages/4f/64/f00272ecbc60703d0f1a3b17ab75d893c05ec5d60b0e6e9d59ef9b8b9c61/aws_sso_util-4.33.0.tar.gz"
  sha256 "e48d7f5911443450d28e1ac1613f81b9aa15babb1b2055b4531df87db43a09df"
  license "Apache-2.0"
  revision 3
  head "https://github.com/benkehoe/aws-sso-util.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "bab323da7693aca57ed3e3471b3cc3f167462798d1387d1ae2d1b0934d602fda"
    sha256 cellar: :any,                 arm64_sonoma:  "6ebabf3294219f2ab3c6f135e90a7cf43e28eaebc1f1765bdb341fe83c6b8bcd"
    sha256 cellar: :any,                 arm64_ventura: "2e4dc4ea27a97b8eeb89059d77842d21f2b6ce42712938f87ec78e2684d00c39"
    sha256 cellar: :any,                 sonoma:        "8ca33fe59987e3a1a0900bfabb01b31fcf5967b7058c3da76ef6dba55136eb6f"
    sha256 cellar: :any,                 ventura:       "323c4ba449820a47dff76a78dab8fdba28467b218d4645f4de7a9ac4e9a02175"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd406c079f352fe10c7e2edd987cd813f40a9dfd05a16b492c91bd0b99bc92e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fdf3d0a107bf8706edae93fd5212debbaafc78289ab384b630b979128379fd3"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "aws-error-utils" do
    url "https://files.pythonhosted.org/packages/2a/fc/2541892cafad6658e9ce5226e54088eff9692cbe4a32cd5a7dfec5846cbf/aws_error_utils-2.7.0.tar.gz"
    sha256 "07107af2a2c26706cd9525b7ffbed43f2d07b50d27e39f9e9156c11b2e993c97"
  end

  resource "aws-sso-lib" do
    url "https://files.pythonhosted.org/packages/3d/df/302bafc5e7182212eec091269c4731bb4469041a1db5e6c3643d089d135d/aws_sso_lib-1.14.0.tar.gz"
    sha256 "b0203a64ccb66ba78f99ef3d0eb669affe7bc323f6ab9caac97f35c21a03cea5"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/70/b0/a35b320e5084821de69a66962513dcc8aa37b7a5bc80e761685533e97be9/boto3-1.38.39.tar.gz"
    sha256 "22cca12cfe1b24670de53e3b8f4c69bdf34a2bd3e3363f72393b6b03bb0d78bc"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/09/61/20eceeccdce79ca238453389e9a8a9147a79417a07e22fa6715f1abd6421/botocore-1.38.39.tar.gz"
    sha256 "2305f688e9328af473a504197584112f228513e06412038d83205ce8d1456f40"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/bf/d3/1cf5326b923a53515d8f3a2cd442e6d7e94fcc444716e879ea70a0ce3177/jsonschema-4.24.0.tar.gz"
    sha256 "0b4e8069eb12aedfa881333004bccaec24ecef5a8a6a4b6df142b2cc9599d196"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/8c/a6/60184b7fc00dd3ca80ac635dd5b8577d444c57e8e8742cecabfacb829921/rpds_py-0.25.1.tar.gz"
    sha256 "8960b6dac09b62dac26e75d7e2c4a22efb835d827a7278c34f72b2b84fa160e3"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/ed/5d/9dcc100abc6711e8247af5aa561fc07c4a046f72f659c3adea9a449e191a/s3transfer-0.13.0.tar.gz"
    sha256 "f5e6db74eb7776a37208001113ea7aa97695368242b364d73e91c981ac522177"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"aws-sso-util",
                                         shells: [:bash, :fish, :zsh], shell_parameter_format: :click)
  end

  test do
    cmd = "#{bin}/aws-sso-util configure profile invalid " \
          "--sso-start-url https://example.com/start --sso-region eu-west-1 " \
          "--account-id 000000000000 --role-name InvalidRole " \
          "--region eu-west-1 --non-interactive"

    assert_empty shell_output "AWS_CONFIG_FILE=#{testpath}/config #{cmd}"

    assert_path_exists testpath/"config"

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
