class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/20/d2/6bcc3ad87e3c6d6737dcc07bef23dbfa18e9de8e08947b8ff5ebfd6ecfab/cfn-lint-0.61.5.tar.gz"
  sha256 "ad43d971f559319c33580e50e9afbae88553512bd944eb3c33bb15fbc21a7df8"
  license "MIT-0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dd4827008049e2d3907143ebaa10da558235edb43fdf3bec47200fafefa7354"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "220355727baec6c5e90534057e96f1c6cb48b3ac1e2a77c18f70e3c8be6d6c6b"
    sha256 cellar: :any_skip_relocation, monterey:       "c8b7bdefa97dc516997336e04522c37f3836dd443c3c22b977003387815bf75e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca8d6ab928d33bbaf36f9843564385070fedd9382722da263c520544e9c2ccb0"
    sha256 cellar: :any_skip_relocation, catalina:       "9918d93ccd6eac25eaff0cc38835047030e3c9f5c2080f06302be9a972a47d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50a420f500737bfe1ef2f923d1e8ff546cb5098421f542868a3e9a0aec46a381"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/42/bf/343dbbd9faaf916273d566ac8f62bfa0c1d22a87c1bdcdb583d1d216ba5b/aws-sam-translator-1.49.0.tar.gz"
    sha256 "a0d3bba2fb16d72e1e4fc5ef50e227e8e6a869f4c417dd760191d26470dca91f"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/80/ca/c973f4cb2f0ccb54b4b61653fa8304701249aaa9589844ec48609a79a639/boto3-1.24.50.tar.gz"
    sha256 "28fefb77fb85b521a87ffd932621b14aabf4bb65ec4f9d9ce7399d093b2ad8bd"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/db/7c/1116dd55dee06d99d4ea304b9554fa1d8e78724fb40ed1259d2672b173bf/botocore-1.27.50.tar.gz"
    sha256 "0a3e2eef7a60c20e46be47eaf45cf5ea7a946aecdb68d829886d4f2506ac657c"
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
    url "https://files.pythonhosted.org/packages/f2/af/fe794d69bcc4882c4905b49c8b207b8dc4dd7ea26e6142781eac8203ea05/networkx-2.8.5.tar.gz"
    sha256 "15a7b81a360791c458c55a417418ea136c13378cfdc06a2dcdc12bd2f9cf09c1"
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
    url "https://files.pythonhosted.org/packages/6d/d5/e8258b334c9eb8eb78e31be92ea0d5da83ddd9385dc967dd92737604d239/urllib3-1.26.11.tar.gz"
    sha256 "ea6e8fb210b19d950fab93b60c9009226c63a28808bc8386e05301e25883ac0a"
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
