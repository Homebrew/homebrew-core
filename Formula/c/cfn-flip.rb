class CfnFlip < Formula
  include Language::Python::Virtualenv

  desc "Convert AWS CloudFormation templates between JSON and YAML formats"
  homepage "https://github.com/awslabs/aws-cfn-template-flip"
  url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
  sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "01055e5f8a5045685b3da9ed70a81bb5fa5730454e412577ab23579b825a9c3e"
    sha256 cellar: :any,                 arm64_ventura:  "71b0e42536f22e0adfa2091d5e88392f315bf988c55e13ab6589af81d2e70711"
    sha256 cellar: :any,                 arm64_monterey: "877d34e0ac9abf259fc72838533e102b04a7e540babfcfe34614ea7621943854"
    sha256 cellar: :any,                 sonoma:         "b0ae466eec5b183208d606e4f57c15b27d37c48cf20762b4490251fd8f5d6881"
    sha256 cellar: :any,                 ventura:        "c2b101fe21682a4de75bd0ad5c26ae5a10154ac73ff307dd7ef69417b11b403f"
    sha256 cellar: :any,                 monterey:       "c215ce2af31666abf8509021f247ae201894f428730403fcab9e0267d8aa2a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "151c0281223f341ee9cbeef8a197007798592d0a6a2eb5a9e6c3c5c9de1f3e37"
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
