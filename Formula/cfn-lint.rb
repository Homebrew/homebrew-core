class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-python-lint/"
  url "https://files.pythonhosted.org/packages/90/93/994a49b78390be5a982fa5dc0ee78831dde5125034b7509cd67864737851/cfn-lint-0.54.2.tar.gz"
  sha256 "82a2cc7d6fa3bbdc303bf1eb87f92ba6b3c552d8aef31918b47b69648ce262d3"
  license "MIT-0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6fbe3fb000c8f32bc137282815afe6a0b7b66235abf1b7fd680430c4dd31ba0d"
    sha256 cellar: :any_skip_relocation, big_sur:       "f5d82c5e6aa77462f13508ef3040e544a6cb4929039c9ffd5ebd2bc1204f414a"
    sha256 cellar: :any_skip_relocation, catalina:      "ab4c8f8d16f03694854581156f403d49e1b6caec444b65be44fe804364bd4499"
    sha256 cellar: :any_skip_relocation, mojave:        "9af266867449f47b83486626affa2f1822ff7aebadc172a1424c67ff399bdd9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42c3702b9ccf13c7dd654c77f585e1a19b3ae4dfe63729941b252813ea2607c0"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/77/42/30a9106f3e712f530cc93f8510364cde417b42acb6b64096a7b34eb0c1b8/aws-sam-translator-1.38.0.tar.gz"
    sha256 "0ecadda9cf5ab2318f57f1253181a2151e4c53cd35d21717a923c075a5a65cb6"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/be/ef/d8b22e8b6c56d054c25cce86035272b2eb8817961b618f0503d543a53c5e/boto3-1.18.47.tar.gz"
    sha256 "07260ec42a21c31a13b07ffbf219811a79be60d2eb9a99cedfec65c2a5f2155d"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/f2/9c/7f5882844cd8eda992ec8a33047761806daeaad109cbb67856991f6c2aec/botocore-1.21.47.tar.gz"
    sha256 "57637772b837da290239b1a9a6676ae2dd8a64833ab7770dc67d169d09bc80b3"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/21/67/83452af2a6db7c4596d1e2ecaa841b9a900980103013b867f2865e5e1cf0/jsonpatch-1.32.tar.gz"
    sha256 "b6ddfe6c3db30d81a96aaeceb6baf916094ffa23d7dd5fa2c13e13f8b6e600c2"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6b/35/400557d3df63269a4c010cbd4865910b3c1718fbfe8d83210b216cd3efcf/jsonpointer-2.1.tar.gz"
    sha256 "5a34b698db1eb79ceac454159d3f7c12a451a91f6334a4f638454327b7a89962"
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

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/f4/d7/0fa558c4fb00f15aabc6d42d365fcca7a15fcc1091cd0f5784a14f390b7f/pyrsistent-0.18.0.tar.gz"
    sha256 "773c781216f8c2900b42a7b638d5b517bb134ae1acbebe4d1e8f1f41ea60eb4b"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
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
