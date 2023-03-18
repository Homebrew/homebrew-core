class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/84/32/256af1fd26f751a71b4e72c3be06baa6538e6409760f9b4822d935cc7d81/cfn-lint-0.75.0.tar.gz"
  sha256 "b95dff0f30bea9ed6d5ab5063eddb9feb416c00c360c6b588b58c0371b00294d"
  license "MIT-0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb3dafd1d4d7e3abca6f7169b08f1b8cc02024ab9e19b110528f379ff4c2cdea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f85fee6b1ce22923c98bf3617f414a3fa56c3eaca19acec89874fc7fc5b58f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d8cd8c00897d3d893823aad04526b4c4a320ae0d40552caffa9bd2b3eab3cc7"
    sha256 cellar: :any_skip_relocation, ventura:        "2ed66f59402acf1a1f5a3a5b5cea39ee817ff0fd4447aff75998b5f36095f019"
    sha256 cellar: :any_skip_relocation, monterey:       "2a341d4742778aef126dd272df92297ea7fe37916c1f64c42a391dd36f195143"
    sha256 cellar: :any_skip_relocation, big_sur:        "45bf91aac7f7a0f43d529496b92b875b2470e59dc8ffb8060b2100ac67d131b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9adb0c8f5ba356b314c7daa28f1ab5646969b16afede2c9370160803022666af"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/a2/0f/c76edb1d62e06279d7b2e8e6b9afcc4154c1a8324c639ff86bd382d5bdce/aws-sam-translator-1.62.0.tar.gz"
    sha256 "2db24633fbc76b8e6eb76adaf0c1001a0d749288af91d85e7d9007e3b05479fa"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/37/10/f606c9db4777f5d7298b7cf696842433d1581732e3b39a2f104e2d2ca9d0/boto3-1.26.92.tar.gz"
    sha256 "401088934097260597495ae3c1842a59a701712a2d0e89443f8ede9161cd3806"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/f2/ab/76eb0fe55dfa93a226440b34dd3545b84ba5d9da0086092bbbc37b57fe2d/botocore-1.29.92.tar.gz"
    sha256 "0bb40ca410ad26c5e9821ab1ab52ea894759ed2188afd99152261c5e895d8c9c"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jschema-to-python" do
    url "https://files.pythonhosted.org/packages/1d/7f/5ae3d97ddd86ec33323231d68453afd504041efcfd4f4dde993196606849/jschema_to_python-1.2.3.tar.gz"
    sha256 "76ff14fe5d304708ccad1284e4b11f96a658949a31ee7faed9e0995279549b91"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/21/67/83452af2a6db7c4596d1e2ecaa841b9a900980103013b867f2865e5e1cf0/jsonpatch-1.32.tar.gz"
    sha256 "b6ddfe6c3db30d81a96aaeceb6baf916094ffa23d7dd5fa2c13e13f8b6e600c2"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/2b/3f/dd9bc9c1c9e57c687e8ebc4723e76c48980004244cf8db908a7b2543bd53/jsonpickle-3.0.1.tar.gz"
    sha256 "032538804795e73b94ead410800ac387fdb6de98f8882ac957fcd247e3a85200"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/a0/6c/c52556b957a0f904e7c45585444feef206fe5cb1ff656303a1d6d922a53b/jsonpointer-2.3.tar.gz"
    sha256 "97cba51526c829282218feb99dab1b1e6bdf8efd1c43dc9d57be093c0d69c99a"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/99/f9/d45c9ecf50a6b67a200e0bbd324201b5cd777dfc0e6c8f6d1620ce5a7ada/networkx-3.0.tar.gz"
    sha256 "9a9992345353618ae98339c2b63d8201c381c2944f38a2ab49cb45a4c667e412"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/8b/87/200171b36005368bc4c114f01cb9e8ae2a3f3325a47da8c710cc58cfd00c/pydantic-1.10.6.tar.gz"
    sha256 "cf95adb0d1671fc38d8c43dd921ad5814a735e7d9b4d9e437c088002863854fd"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "sarif-om" do
    url "https://files.pythonhosted.org/packages/ba/de/bbdd93fe456d4011500784657c5e4a31e3f4fcbb276255d4db1213aed78c/sarif_om-1.0.4.tar.gz"
    sha256 "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.yml").write <<~EOS
      ---
      AWSTemplateFormatVersion: '2010-09-09'
      Resources:
        # Helps tests map resource types
        IamPipeline:
          Type: "AWS::CloudFormation::Stack"
          Properties:
            TemplateURL: !Sub 'https://s3.${AWS::Region}.amazonaws.com/bucket-dne-${AWS::Region}/${AWS::AccountId}/pipeline.yaml'
            Parameters:
              DeploymentName: iam-pipeline
              Deploy: 'auto'
    EOS
    system bin/"cfn-lint", "test.yml"
  end
end
