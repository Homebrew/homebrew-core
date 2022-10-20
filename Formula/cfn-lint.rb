class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/93/3e/d0cdabb490c5933908a6572d8ff8924a40087187ac923f4cc8a8646ddcb4/cfn-lint-0.68.0.tar.gz"
  sha256 "3c68a6f912e5780e4fa23e5033b9c9d65e7612cc1b4b0cfb01d03260af120a3e"
  license "MIT-0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "731394827b11e7a6fc0c3fbf387d2e03aacb0d3f625662ffe7537d48ce96ae1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9464d11b445b33b66d89cf369ca4864a96697cc8c344b987bc632ae69e17ba2"
    sha256 cellar: :any_skip_relocation, monterey:       "d12f4bc166e7b016632e91c8634f49645fbc4715c68aa8209ee87da94bf454cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b2af91d0af0858c5d096006fef5a7173b963841a92718cb6c9eeb58c877927f"
    sha256 cellar: :any_skip_relocation, catalina:       "7f75b06e3ab1165220ec929f5640118ae19e2c6cf4eebbf9bf1166367c89e819"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39019bcd29aee7337b132a97707eef752344cac87aa719ededbff4061af4116b"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/41/5f/7a38af115796ad4f134e6caab373a6931d867a4fc08e3312a794f1256c0c/aws-sam-translator-1.53.0.tar.gz"
    sha256 "392ed4f5fb08f72cb68a8800f0bc278d2a3b6609bd1ac66bfcdeaaa94cdc18e5"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/6c/54/0b88f03a606410f399d5ce511bec606bd9051bf4c658d0388660537cc90e/boto3-1.24.93.tar.gz"
    sha256 "7881fc380f2f489ae9b3a2f2448334aef9f7be58d85a7a0e8c10458247b09afa"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/1b/42/6baa60b44655bc3fc520e2fe8a6e37fdc790662b39cd627b7d40a5a8a361/botocore-1.27.93.tar.gz"
    sha256 "d5200f7b9150cdb91c9d3994980870d7bb4554e19c4d9d847f64626d8ceacf95"
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
    url "https://files.pythonhosted.org/packages/9e/89/90846e0da5c412cbffb66d1f976b056cd46c6f2aa7f2f1eb271573b5fefb/networkx-2.8.7.tar.gz"
    sha256 "815383fd52ece0a7024b5fd8408cc13a389ea350cd912178b82eed8b96f82cd3"
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
