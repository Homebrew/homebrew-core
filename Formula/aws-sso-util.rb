class AwsSsoUtil < Formula
  include Language::Python::Virtualenv

  desc "Smooth out the rough edges of AWS SSO (temporarily, until AWS makes it better)"
  homepage "https://github.com/benkehoe/aws-sso-util"
  url "https://files.pythonhosted.org/packages/f7/eb/ab159867dec525c0a17a17bce55ed751ef9eb9f2e3e4e3ebffa26b3f0522/aws-sso-util-4.29.0.tar.gz"
  sha256 "b78dba34a678564ca0ffe9e5fba7e2229675f69a8806fd89ef0839258d084384"
  license "Apache-2.0"
  head "https://github.com/benkehoe/aws-sso-util.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "473ee46d0376ea2ddf8f538bb50304987978892f1637c9357d0658e15a2d4194"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "151d91c9d4d6c93b7388c6af3eaea913550533ae80fbb0a5783aee27821d41a3"
    sha256 cellar: :any_skip_relocation, monterey:       "37882389b3b700d1b023fb951fa3820290f08092c6c13a183cffbe308e7c7668"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3de287508b57b7892035987d1511c20cc22093dd8338b077bceeb8b3ee5c157"
    sha256 cellar: :any_skip_relocation, catalina:       "fb9719825f17a9a8ee0a8dda530be7388b21df2651e57db1d33c6cfad912167b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05be4da03fbbd8f76ae4156923b7b30b83c8c77f1f5d627a449e91ff0a419a00"
  end

  depends_on "rust" => :build
  depends_on "python@3.10"
  depends_on "six"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "aws-error-utils" do
    url "https://files.pythonhosted.org/packages/4e/7b/622c18e41b17935ac72f4f7b8775e18fe6dd6ecca0d1068fd95f5cbd91f9/aws-error-utils-1.3.0.tar.gz"
    sha256 "188159a8897552408dc3545aed55b49a12532cbde841aad0490e2b93a1275cfc"
  end

  resource "aws-sso-lib" do
    url "https://files.pythonhosted.org/packages/78/06/fb9f7af1dfafb98ae253b314625c116091e86fa4aa2dd2bab4ab42f68bbc/aws-sso-lib-1.12.0.tar.gz"
    sha256 "a12579823deace1db78efb223cb74a758127ca6b74e6adbd2b1add1c9b45b717"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/72/63/baebfcb18a2ff05b26b6603fd73f262ce5155c1cbc9adb7f00240ad82dd9/boto3-1.24.71.tar.gz"
    sha256 "0ee555dc0f362d2761d86e0264ee79985b09de4289334fbec7de384b39ccce72"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/d5/20/458287e7879f8a1fbe50076370b1487a3a3e6b1299543cfdf706f27a9edf/botocore-1.27.71.tar.gz"
    sha256 "91dc4e8ae768db3a5c26ef8acd6425bbbec4b17636350d526c226a5879d3c613"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/90/c2/4e37394b66e7211ad120f216fc2e8b38d4f43b89c8100dd3917c9da9bfc6/certifi-2022.6.15.1.tar.gz"
    sha256 "cffdcd380919da6137f76633531a5817e3a9f268575c128249fb637e4f9e73fb"
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
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
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
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
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
