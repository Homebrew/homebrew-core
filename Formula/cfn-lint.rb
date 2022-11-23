class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/c3/01/7b9a005bef9977f80f9ee296e804c7ab74f764ccb95417c5b8818dca4bb8/cfn-lint-0.72.0.tar.gz"
  sha256 "7050182c083ee8eb386c60ca7073c72ea067d39238af116b0fb282b130bb39f0"
  license "MIT-0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "921e0677728281b762a454a8a76ce7e83f04b129d207a7ef71c2e924f781dff6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b6fb0687ec21b3d541e2069c23d396c7f290bdb5424cfc5a476239b530da73e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6805df1b83a856e38558fd4befcde5dc6931bd6432bbf316531908b3f14f2cae"
    sha256 cellar: :any_skip_relocation, ventura:        "3666f3dd245b26d6b63a511f26e88f86cb03f44397c48c7a45e3993b2cf1ccdd"
    sha256 cellar: :any_skip_relocation, monterey:       "6f4c2f515a669192118e4dfcce040884dcca12c915db2afc7a0b0f4a64a63bf5"
    sha256 cellar: :any_skip_relocation, big_sur:        "54de55fcbb0f6c5b516dcf26335ff6697c4f8d1f21dbc0ed09964e601538e8a7"
    sha256 cellar: :any_skip_relocation, catalina:       "31d2c158f6237788e2d1f6f01d5200a6c55f39c63f155393211e45a2c3e8b522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ae1298f50e5800cfff61e77df9b10c0b67ac50ac275b1a6f501c5e5fa328ebe"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/d3/47/c7b4eb84fb294f294df45fc75cf8e1fb987535f5adbda5d2e53c47e0a2de/aws-sam-translator-1.54.0.tar.gz"
    sha256 "a3ae79f1f2d430f5ade4d245165d5612414233f540b471d170f1aab95c3713a6"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/79/3b/e5ac869eddae93234e95f780ce11c3daa8e5b1b61a88af38242e2e4dc2b8/boto3-1.26.15.tar.gz"
    sha256 "e2bfc955fb70053951589d01919c9233c6ef091ae1404bb5249a0f27e05b6b36"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/31/82/1122906f8f8f24b5431855b2a43de385cdcb72fad8b5ca21fd8bdb59e50f/botocore-1.29.15.tar.gz"
    sha256 "7d4e148870c98bbaab04b0c85b4d3565fc00fec6148cab9da96ab4419dbfb941"
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
    url "https://files.pythonhosted.org/packages/cd/16/c44e8550012735b8f21b3df7f39e8ba5a987fb764ac017ad5f3589735889/networkx-2.8.8.tar.gz"
    sha256 "230d388117af870fce5647a3c52401fcf753e94720e6ea6b4197a5355648885e"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/52/fb/630d52aaca8fc7634a0711b6ae12a0e828b6f9264bd8051225025c3ed075/pbr-5.11.0.tar.gz"
    sha256 "b97bc6695b2aff02144133c2e7399d5885223d42b7912ffaec2ca3898e673bfe"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/b8/ef/325da441a385a8a931b3eeb70db23cb52da42799691988d8d943c5237f10/pyrsistent-0.19.2.tar.gz"
    sha256 "bfa0351be89c9fcbcb8c9879b826f4353be10f58f8a677efab0c017bf7137ec2"
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
