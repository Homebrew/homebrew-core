class AwsSsoUtil < Formula
  include Language::Python::Virtualenv

  desc "Smooth out the rough edges of AWS SSO (temporarily, until AWS makes it better)"
  homepage "https://github.com/benkehoe/aws-sso-util"
  url "https://files.pythonhosted.org/packages/6b/ea/2241ca0f8f3b2033a283ef06b9a03164559388d7cc1af9d20048d50cd578/aws-sso-util-4.30.0.tar.gz"
  sha256 "cfdca8877e7ab0a2dd9e360af45e9cb11420f7f8c31cec2c3b12f41d0a4f7f3a"
  license "Apache-2.0"
  head "https://github.com/benkehoe/aws-sso-util.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "644061e3b2149f86fffa3d191326d054a85e341c1c9edd373485a622f4d8ddfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcd9c76459e9fd7e96e53e84a4b26f845b27c87b24d4a55146716bc85db201c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b2420f4ea6bb3a13d35672db645031fc3a4770c215b49e9fd018118e4642bb8"
    sha256 cellar: :any_skip_relocation, ventura:        "3ade2ba8d4684edda7d8bd76af958537bfe3dc92b535047a94103d3220a86422"
    sha256 cellar: :any_skip_relocation, monterey:       "3596886db39bb8ec8d88bc161d913d31a32d05166f93a65393843a9ecc9225b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "db5eb1bd65c0c06f5d534235f133c18fd2892034598193104bcabf695c0b4fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aef2aaa71e70de99b18828a65103208d1c0449db3f12fcacd28166c03674d5cc"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "aws-error-utils" do
    url "https://files.pythonhosted.org/packages/4e/7b/622c18e41b17935ac72f4f7b8775e18fe6dd6ecca0d1068fd95f5cbd91f9/aws-error-utils-1.3.0.tar.gz"
    sha256 "188159a8897552408dc3545aed55b49a12532cbde841aad0490e2b93a1275cfc"

    # Use poetry_core backend to avoid unnecessary cmake and rust build dependencies.
    # Remove when release uses aws-error-utils>=2.6.
    # Backport of https://github.com/benkehoe/aws-error-utils/commit/f23a4bb8703e8ffabf1d008e04495572cc12d4ee
    patch :DATA
  end

  resource "aws-sso-lib" do
    url "https://files.pythonhosted.org/packages/73/d3/8e8c24d0c7b6ee6861cc00aab33c3aa5736b4038a809d36f254b77e06a39/aws-sso-lib-1.13.0.tar.gz"
    sha256 "809ec5dcdcd84d62141ade6490ced369836ea237d5bcb2a69aac1dd93e15c49f"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/2d/07/d0427a01e4bf4b00bd72eadc795587e22c5be064aba0aa1b60d9d2d9f1c5/boto3-1.26.37.tar.gz"
    sha256 "82b790b1dabd0746b028d2013b5d4d636a41f3aaf25520081f4c173cb6eb395d"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/c2/27/b2343f0676d636e7dbf9daf9a51422fc1f28116f4842c274c9ad43aa5aec/botocore-1.29.37.tar.gz"
    sha256 "3afa4fec9f7713caa05116563b38f81bec7bd20585d517155484d3f25efab5aa"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/b8/ef/325da441a385a8a931b3eeb70db23cb52da42799691988d8d943c5237f10/pyrsistent-0.19.2.tar.gz"
    sha256 "bfa0351be89c9fcbcb8c9879b826f4353be10f58f8a677efab0c017bf7137ec2"
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
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    cmd = "#{bin}/aws-sso-util configure profile invalid " \
          "--sso-start-url https://example.com/start --sso-region eu-west-1 " \
          "--account-id 000000000000 --role-name InvalidRole " \
          "--region eu-west-1 --non-interactive"

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

__END__
diff --git a/pyproject.toml b/pyproject.toml
index e130aed..e60f2ac 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -25,5 +25,5 @@ pytest = "^5.4.2"
 pylint = "*"

 [build-system]
-requires = ["poetry>=0.12"]
-build-backend = "poetry.masonry.api"
+requires = ["poetry_core>=1.0.0"]
+build-backend = "poetry.core.masonry.api"
