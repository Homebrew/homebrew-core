class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/e0/79/db8252d13a2450395ed03d70507d2c6a10ef1aa579086d24b7610984bc5b/cfn-lint-0.63.0.tar.gz"
  sha256 "7168df5dfbab51a5dce0c25530507edecdf359c99dcc3fc0871cd5de7cd81695"
  license "MIT-0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b47e8da2a3b3ba876da328a4e1ca0b038561368b6ecbc4768945d17a1251a10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed24cff7427345a0931e3919b37603bab8c4a596a62ad7868350ee650714b3e4"
    sha256 cellar: :any_skip_relocation, monterey:       "f5c471380775db69339f5fab8c3105d6cbfc75fb72ce4bc8181300a5323d4fd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "45e5ec3b34732ec3ade680df11361ea3732fbfceac8c75b471f906800b61d0b5"
    sha256 cellar: :any_skip_relocation, catalina:       "bd0b22827863b0758c98a81868666d7570f84a53fe22b9bf12b39c01a7c5a1ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9633229b888140646d7536fb0aa6a697adb0306d94fe8418cafafc40b1ad3b12"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/7b/c1/e7933aefe6c8ff8d2320fafc2f7160a6306e540c2c6372797a1f7f8f66d3/aws-sam-translator-1.50.0.tar.gz"
    sha256 "85bea2739e1b4a61b3e4add8a12f727d7a8e459e3da195dfd0cd2e756be054ec"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/3f/3b/eac5f57a495da702f34eb7c1f34a325d122c4e2f9ffd99bac5eddf7ddbd1/boto3-1.24.59.tar.gz"
    sha256 "a50b4323f9579cfe22fcf5531fbd40b567d4d74c1adce06aeb5c95fce2a6fb40"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/94/29/b8ef249300edf4584384f725d20db126b6caf6147aac4d02efebca239dce/botocore-1.27.59.tar.gz"
    sha256 "eda4aed6ee719a745d1288eaf1beb12f6f6448ad1fa12f159405db14ba9c92cf"
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

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
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
