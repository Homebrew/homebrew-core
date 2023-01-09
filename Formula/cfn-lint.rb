class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/f6/71/023a8e21e38c6a9d8f2513b9b9a80403727af0cb2d4cf7f2f0814bbd14d7/cfn-lint-0.72.7.tar.gz"
  sha256 "b6559dd44015947b17f3c0b0d5f38a4bbdadccbb13b6000c96f1a22241f2b69c"
  license "MIT-0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ba399e92c08a167fe15e0090c22db8cd2b88f41b555eed7fe832226b6a932f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baaa10fbed023792d4fd7e1e8b9fc5f743ce68560352f765ab18a39f3d0d02c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b248d4b331a5ae32baebf07c740824bdc6c0c6b48d281d8184753e4181d574d"
    sha256 cellar: :any_skip_relocation, ventura:        "7991b120570498f75f34d425a3748842cd6d6d2f436797047d8294cb166d3955"
    sha256 cellar: :any_skip_relocation, monterey:       "a77123e65340320b03a765d210ed8f334831b450caad7f27cef695c82a9e3853"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c78e764bc9a960feebf322ff787443f35a8a9cd4cff120821af1513c76ccba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86ba1e58211b48d9df04f9b6ad9221b4691332b3e0b9cb95411d2b20999d56e2"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/96/c5/288763b89ab5b19da52cf099e4e23edd661e9fe06a853996ff16214f5de1/aws-sam-translator-1.56.0.tar.gz"
    sha256 "ba97287f5ffc8bc55759f3a416230a27ce26d8c0118e77b9737fa700781bd816"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/e5/c0/763f924ea24f55b8041232fd778305418518b82a10285af4e190d1c24450/boto3-1.26.46.tar.gz"
    sha256 "e24d65c31780c208768ebcd152d8a0181591c9c8e7d971e23f318d7f41910ba1"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/bb/96/298f61ff79e6608596a5c74fd9641faba36dd8f6cc2519d4e74603262e67/botocore-1.29.46.tar.gz"
    sha256 "78bf25933e35eb6354a9e80fe156f86dce4d346a92afe364dfce25c17ab0639f"
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

  # only doing this because junit-xml source is not available in PyPI for v1.9
  resource "junit-xml" do
    url "https://github.com/kyrus/python-junit-xml.git",
        revision: "4bd08a272f059998cedf9b7779f944d49eba13a6"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/cd/16/c44e8550012735b8f21b3df7f39e8ba5a987fb764ac017ad5f3589735889/networkx-2.8.8.tar.gz"
    sha256 "230d388117af870fce5647a3c52401fcf753e94720e6ea6b4197a5355648885e"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/52/fb/630d52aaca8fc7634a0711b6ae12a0e828b6f9264bd8051225025c3ed075/pbr-5.11.0.tar.gz"
    sha256 "b97bc6695b2aff02144133c2e7399d5885223d42b7912ffaec2ca3898e673bfe"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/53/17/34e54e352f6a3d304044e52d5ddd5cd621a62ec8fb7af08cc73af65dd3e1/pydantic-1.10.4.tar.gz"
    sha256 "b9a3859f24eb4e097502a3be1fb4b2abb79b6103dd9e2e0edb70613a4459a648"
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

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/e3/a7/8f4e456ef0adac43f452efc2d0e4b242ab831297f1bac60ac815d37eb9cf/typing_extensions-4.4.0.tar.gz"
    sha256 "1511434bb92bf8dd198c12b1cc812e800d4181cfcb867674e0f8279cc93087aa"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
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
