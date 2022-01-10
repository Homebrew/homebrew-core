class AwsSsoUtil < Formula
  include Language::Python::Virtualenv

  desc "Smooth out the rough edges of AWS SSO (temporarily, until AWS makes it better)"
  homepage "https://github.com/benkehoe/aws-sso-util"
  url "https://files.pythonhosted.org/packages/74/05/b89d999b662d955ff362ebdf9a4494bd0966deaa689ef65f5fbbf175febc/aws-sso-util-4.26.0.tar.gz"
  sha256 "10a5b6919b8931f83217968758528880aeee6059f65cebf4e4ed926294129c89"
  license "Apache-2.0"
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
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "aws-error-utils" do
    url "https://files.pythonhosted.org/packages/d6/a5/4b1213a8789314adb4a6d465fd77aec32f12bb2fedaa197525cbd4aedd32/aws-error-utils-1.2.0.tar.gz"
    sha256 "164f2a5bdd69c4cecc647d6e080c21243472c44c4d3caba15908f69d7fcfe16b"
  end

  resource "aws-sso-lib" do
    url "https://files.pythonhosted.org/packages/5a/07/ec48f0a588325450d3bf9592a482477063de01eaf8150c6aa8e45a667a7d/aws-sso-lib-1.9.0.tar.gz"
    sha256 "d278c7ca3adb0dc1e4ea05c24621ff109786d771928950e939d0285d040036f3"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ef/9c/8ad10de7177dec675a25397ffe922be9d9f42d35483ed1b983b8af4c810a/boto3-1.20.31.tar.gz"
    sha256 "3003d64ebef678b89a9909d2df3836160c7cbad5cbfe6c995a61de0875b36237"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/4b/81/e94b2fce65006f17b46e9f87ae09dd5a69578b4b807d0d2f862958b962d5/botocore-1.23.31.tar.gz"
    sha256 "bb34fa60ab894f9a4a1f7de36e32a68ce17f302108f83732c3ca99c7da2bf68c"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/48/44/76b179e0d1afe6e6a91fd5661c284f60238987f3b42b676d141d01cd5b97/charset-normalizer-2.0.10.tar.gz"
    sha256 "876d180e9d7432c5d1dfd4c5d26b72f099d503e8fcc0feb7532c9289be60fcbd"
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

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
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
