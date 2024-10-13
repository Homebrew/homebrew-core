class CfnFlip < Formula
  include Language::Python::Virtualenv

  desc "Convert AWS CloudFormation templates between JSON and YAML formats"
  homepage "https://github.com/awslabs/aws-cfn-template-flip"
  url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
  sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "56fe9fe6185019ce53a85c5ddc71abbd373c24c27bb26a4ba6e73463b89b1df4"
    sha256 cellar: :any,                 arm64_sonoma:  "6adc448d4253f808ffc13a4d4191acd29608047c62f573916567bd5dee5cd37c"
    sha256 cellar: :any,                 arm64_ventura: "e7a1d40f2eedb27478defd049e6779b5f8717c583f3ea3b1c8b293f3ef3bbea7"
    sha256 cellar: :any,                 sonoma:        "fb306034d555f7d8bef38114f949c89c0af36747814cb7fe91d7c59367614c96"
    sha256 cellar: :any,                 ventura:       "29d0c987000711a22b22cf4035132104e7e3decaae3980f7ef347139c6c0d30e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f53b22e1f37ddd7932bc70841da5bf64cff519693b166098a0309642a539406"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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
