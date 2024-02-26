class CfnFlip < Formula
  include Language::Python::Virtualenv

  desc "Convert AWS CloudFormation templates between JSON and YAML formats"
  homepage "https://github.com/awslabs/aws-cfn-template-flip"
  url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
  sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 6
    sha256 cellar: :any,                 arm64_sonoma:   "0c33c1b5656b50bf90c99951eed5ee382af177d5632d2f03209c11ca4d686882"
    sha256 cellar: :any,                 arm64_ventura:  "289effc7b26137d6a94abc5ebdfd51e544c128d3e13c268c9c5202ec31b7a2d6"
    sha256 cellar: :any,                 arm64_monterey: "8fe7485220c3e64d5cfa6eaf9a63fbc6ec0e5e8383867c2cdaa704173e2c17e6"
    sha256 cellar: :any,                 sonoma:         "fe168805ac857d97c45dc33a4ddd09943e9f70f3a80c38e9a8c2581892d84db7"
    sha256 cellar: :any,                 ventura:        "0ec749160a01b0287c4a7749f7ff52c9843e98f41c8bd1e5ba63485aaf39a5df"
    sha256 cellar: :any,                 monterey:       "d8ee2e1a6d1602eb6ef4c7ccff05bc5ebde3ef85f542cbb9037acef4b7c9b0b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "366bbe67359faaabc8549898143985362e1aac613e5c1536512f3868ce8c2505"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.json").write <<~EOS
      {
        "Resources": {
          "Bucket": {
            "Type": "AWS::S3::Bucket",
            "Properties": {
              "BucketName": {
                "Ref": "AWS::StackName"
              }
            }
          }
        }
      }
    EOS

    expected = <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
          Properties:
            BucketName: !Ref 'AWS::StackName'
    EOS

    assert_match expected, shell_output("#{bin}/cfn-flip test.json")
  end
end
