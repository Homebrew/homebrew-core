class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-python-lint/"
  url "https://files.pythonhosted.org/packages/c2/40/86c4ff5139e1b5dde47d4e9bd484b052110014c70d21746de89db1d72c80/cfn-lint-0.56.0.tar.gz"
  sha256 "3e39895bc844506f774889bfd3b71db2cdd7ee76bb52102f518dd55b854091fe"
  license "MIT-0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ecf859cc37964d12aee38679a449ef0157b8a76fc7503e1e4ea4b6b7d9713ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e649b535210b0d0208f98bd6de44141cb309cf5e59fdf3052c05e5f31c286083"
    sha256 cellar: :any_skip_relocation, monterey:       "3ac1441e1b3cf9d39797db33cb30e4ae00c6e1ed4d43543824cc645a9e93e8cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "94c82def7c7acb197d09398fe5669420692b101121bb971da86ecac6ac2a9a03"
    sha256 cellar: :any_skip_relocation, catalina:       "2bf6b32498eba63cc9297133916071b83a43d7519b8b9f748cba646afc2c4aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "511904e7c3133f0eaeb752f4914b7995affbcfe82a1353183f3d5a4f66b3c57f"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/3c/9e/c6ad47c90eb4d3c0a53d139a28c4df13bfb2dd6996a201cc4a1addbaaae0/aws-sam-translator-1.40.0.tar.gz"
    sha256 "ae52c5941048ea7e4a2fd268dbd5d34a133e128913a641f41c9360f6d77b05c3"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/6d/25/82cdd634d24a53fcf2eac96a73a776c85a26a3c39ca8da234a3d4d0d0f30/boto3-1.19.12.tar.gz"
    sha256 "182a2b756a2c2180b473bc8452227062394a24e3701548be23ebc30d85976c64"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/58/06/a1648e8b32dacf21b3fc732fc2d3c74a6ef943af637f55fc7039ca657afd/botocore-1.22.12.tar.gz"
    sha256 "fc59b55e8c5dde64b017b2f114c25f8cce397b667e812aea7eafb4b59b49d7cb"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
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
    url "https://files.pythonhosted.org/packages/62/8a/84864798c5ef120e3a5b5cf08d8c231fa4499b53d465488563c4cb901f2f/jsonpickle-2.0.0.tar.gz"
    sha256 "0be49cba80ea6f87a168aa8168d717d00c6ca07ba83df3cec32d3b30bfe6fb9a"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/29/7f/e6b5930e6dd1f461ad412dfc40bc94e5235011f6bbf73cafa8074617c203/jsonpointer-2.2.tar.gz"
    sha256 "f09f8deecaaa5aea65b5eb4f67ca4e54e1a61f7a11c75085e360fe6feb6a48bf"
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
    url "https://files.pythonhosted.org/packages/97/ae/7497bc5e1c84af95e585e3f98585c9f06c627fac6340984c4243053e8f44/networkx-2.6.3.tar.gz"
    sha256 "c0946ed31d71f1b732b5aaa6da5a0388a345019af232ce2f49c766e2d6795c51"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/69/7e/e420b9b6b06f9597827571e871f9492512701497971a4cf3f4638c03bc7a/pbr-5.7.0.tar.gz"
    sha256 "4651ca1445e80f2781827305de3d76b3ce53195f2227762684eb08f17bc473b7"
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
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "sarif-om" do
    url "https://files.pythonhosted.org/packages/ba/de/bbdd93fe456d4011500784657c5e4a31e3f4fcbb276255d4db1213aed78c/sarif_om-1.0.4.tar.gz"
    sha256 "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
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
