class CfnFlip < Formula
  include Language::Python::Virtualenv

  desc "Convert AWS CloudFormation templates between JSON and YAML formats"
  homepage "https://github.com/awslabs/aws-cfn-template-flip"
  url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
  sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  license "Apache-2.0"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sequoia: "5442b8b312ae32f1f553fb978ccf09c63a8faec827d97d1c0ee6c25e6b8bec69"
    sha256 cellar: :any,                 arm64_sonoma:  "e34be5905def03dfd1a3b2e978175a2a20c04c9a707526437f747f290f72d575"
    sha256 cellar: :any,                 arm64_ventura: "0f477d1324b35e9d08f22bf9440d350dbef9eb7064a4a349dc61634037ccdc38"
    sha256 cellar: :any,                 sonoma:        "8621b8bd4592dbff5713e74fe7ba0e2df3e49ed586b11dd29f28c8cd3a716579"
    sha256 cellar: :any,                 ventura:       "0cbd0c1da955391882c5993e2c5ca0673b31aa9e96ccfa4735efe0bd179ec41d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cfc26cd8e493d0423d00e49da1185a278aa84b79e3cd4325678fb161856607a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f22cd5a684f506f67a27cb9bcd7c4a9192909ec3222ae9b87eacba18776f43c8"
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

    generate_completions_from_executable(bin/"cfn-flip", shells: [:bash, :fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath/"test.json").write <<~JSON
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
    JSON

    expected = <<~YAML
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
          Properties:
            BucketName: !Ref 'AWS::StackName'
    YAML

    assert_match expected, shell_output("#{bin}/cfn-flip test.json")
  end
end
