class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/d5/2c/70cdc9da61b7cc27733735d0d52832aaa32747e7dbcffe321892ec694c00/cfn-lint-0.66.0.tar.gz"
  sha256 "d786da1199575e7fff4e156185365bb5f93fb4a7d678cabcfe804fa00ed8a06f"
  license "MIT-0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b33648d6380a1313a3b9336edde329e33568e74279dc1df9c2319b36252fabb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3d657ab367dc9f8e029b32bbe93c7b3fa809e81e4b95b00d5bc1e6a1cf343a9"
    sha256 cellar: :any_skip_relocation, monterey:       "f5f430bf760ccaf91d3935d3c62a562deeb2c75571f42c8ecc52946a13fdda82"
    sha256 cellar: :any_skip_relocation, big_sur:        "75dcf113f1ff2d967b839c157c6fa56fd0c45e874b4343accb2d3f8519bc0cea"
    sha256 cellar: :any_skip_relocation, catalina:       "108f219cdbbb9a0449362f637e1b64467f6e15355cc2af7bcaa33ca983b7c202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db71f74c7c8fa03246816167a5ff8ff903e7a30eaeafb5877fcd211a37527f43"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/3e/71/ae7afb44d810382896eca910bd856cb3589854353a36c09a5716228889a6/aws-sam-translator-1.51.0.tar.gz"
    sha256 "4c39d78dd92a8d4b46b5b02dc74e6f0ef8713109ebc8910aec234c3b18649ffb"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/9f/e8/844f0d8f0e26e049f8599324e71602ae9b769d529cef29073d4b33526d84/boto3-1.24.83.tar.gz"
    sha256 "b10d9ecaba3f0ed844192828d2c2b26bfa1dfd2b40ccccc25507575f28097e32"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/e5/1d/f3044b25b8ae773183528e32360352cd7206725c4fdc7717679f5788e395/botocore-1.27.83.tar.gz"
    sha256 "c57f74322cf672405f0ec7ee8fda7d80d323a9c664a90926c11313ca3bfbca91"
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
    url "https://files.pythonhosted.org/packages/65/09/50bc3aabaeba15b319737560b41f3b6acddf6f10011b9869c796683886aa/jsonpickle-2.2.0.tar.gz"
    sha256 "7b272918b0554182e53dc340ddd62d9b7f902fec7e7b05620c04f3ccef479a0e"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/a0/6c/c52556b957a0f904e7c45585444feef206fe5cb1ff656303a1d6d922a53b/jsonpointer-2.3.tar.gz"
    sha256 "97cba51526c829282218feb99dab1b1e6bdf8efd1c43dc9d57be093c0d69c99a"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  # only doing this because junit-xml source is not available in PyPI for v1.9
  resource "junit-xml" do
    url "https://github.com/kyrus/python-junit-xml.git",
        revision: "4bd08a272f059998cedf9b7779f944d49eba13a6"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/d9/c6/ad9dc9195c0e5d8879d2a28667aa45e087631576b40f9c954a086693a36d/networkx-2.8.6.tar.gz"
    sha256 "bd2b7730300860cbd2dafe8e5af89ff5c9a65c3975b352799d87a6238b4301a6"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/b4/40/4c5d3681b141a10c24c890c28345fac915dd67f34b8c910df7b81ac5c7b3/pbr-5.10.0.tar.gz"
    sha256 "cfcc4ff8e698256fc17ea3ff796478b050852585aa5bae79ecd05b2ab7b39b9a"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/42/ac/455fdc7294acc4d4154b904e80d964cc9aae75b087bbf486be04df9f2abd/pyrsistent-0.18.1.tar.gz"
    sha256 "d4d61f8b993a7255ba714df3aca52700f8125289f84f704cf80916517c46eb96"
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
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
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
