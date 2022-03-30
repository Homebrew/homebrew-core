class AwsSsoUtil < Formula
  include Language::Python::Virtualenv

  desc "Smooth out the rough edges of AWS SSO (temporarily, until AWS makes it better)"
  homepage "https://github.com/benkehoe/aws-sso-util"
  url "https://files.pythonhosted.org/packages/b4/c3/917e6858249056e5d0bba19f52813e726fba29da456c2db7952053048529/aws-sso-util-4.28.0.tar.gz"
  sha256 "2300079d57aec85f7ed4e8c01548b5c8ea49e6f838b8532701bf91c975dbba1d"
  license "Apache-2.0"
  head "https://github.com/benkehoe/aws-sso-util.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d544caaa5226b322fbaa56372a15f81de57a0b0eb1be97d2d8928f0310c896a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6a31f1e1ec5a6d702c9f6b7e95052155cd6d4bb47175ced17e7254d884eb3eb"
    sha256 cellar: :any_skip_relocation, monterey:       "88ef3f579367b55d45b9e7c9a34c0aecedd27b925b5c5bea47c5b96dbb2b40f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "45265ba19d72268891fac5c4f044162bd164d9e72327d943350c223b12a75ff7"
    sha256 cellar: :any_skip_relocation, catalina:       "5ee5224a74febf0b2ad84654a669b4a9248947d894f7b09d652faa840a14d531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96197d65bf9c74871ef1cc25e51955ba8db44f317ab85c863fd4b86f2c81a8f0"
  end

  depends_on "rust" => :build
  depends_on "python@3.10"
  depends_on "six"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "aws-error-utils" do
    url "https://files.pythonhosted.org/packages/4e/7b/622c18e41b17935ac72f4f7b8775e18fe6dd6ecca0d1068fd95f5cbd91f9/aws-error-utils-1.3.0.tar.gz"
    sha256 "188159a8897552408dc3545aed55b49a12532cbde841aad0490e2b93a1275cfc"
  end

  resource "aws-sso-lib" do
    url "https://files.pythonhosted.org/packages/64/97/f2c08a8a1b60d42d8083392669962a2218cdf4ed7e4d62f961a89f4a4375/aws-sso-lib-1.11.0.tar.gz"
    sha256 "ec95a1a690e618961b9304554c647c933aeb17e2ef5bad290a83e554bea24008"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/fd/2f/fe2b44be11e97d8056f56e6881666d2e215ab3ed1aa18e6f9d4da56f6326/boto3-1.21.29.tar.gz"
    sha256 "127ebdf58c8825b53f1eff111e08c49ffffeb1f6d7a5665c9907ce8128fe14b1"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/72/c2/beeb5b9efbd2bf9353898ad07968acc443d7bb376b02d8193b93d2590ede/botocore-1.24.29.tar.gz"
    sha256 "b467d64cd773dc4d49ef31b18a8dded554f284f799720bd12e989fe2138fd5b8"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/06/7e/44686b986ef9ca6069db224651baaa8300b93af2a085a5b135997bf659b3/jmespath-1.0.0.tar.gz"
    sha256 "a490e280edd1f57d6de88636992d05b71e97d69a26a19f058ecf7d304474bf5e"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/42/ac/455fdc7294acc4d4154b904e80d964cc9aae75b087bbf486be04df9f2abd/pyrsistent-0.18.1.tar.gz"
    sha256 "d4d61f8b993a7255ba714df3aca52700f8125289f84f704cf80916517c46eb96"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/7e/19/f82e4af435a19b28bdbfba63f338ea20a264f4df4beaf8f2ab9bfa34072b/s3transfer-0.5.2.tar.gz"
    sha256 "95c58c194ce657a5f4fb0b9e60a84968c808888aed628cd98ab8771fe1db98ed"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
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
