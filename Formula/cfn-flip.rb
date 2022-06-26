class CfnFlip < Formula
  include Language::Python::Virtualenv

  desc "Convert AWS CloudFormation templates between JSON and YAML formats"
  homepage "https://github.com/awslabs/aws-cfn-template-flip"
  url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
  sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75a83673127fec043584cb8f92c7526eef72475d7f3502568ba48f190e73f82f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c35c36d9db398cb2685e977f6367fd45f9cef1b86284a6b42d56ee81a7a24acd"
    sha256 cellar: :any_skip_relocation, monterey:       "ecb3dba5049db0bd732cdb472aa2afda1ec8293f0bbcbdee4a549d1b578895b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f728b55aa81f3607d306f7d971fc3ef3869705a951eecdf7fa9835947d776a5"
    sha256 cellar: :any_skip_relocation, catalina:       "6d22b33221912b856ce5e91c2735a9d49c87135a9dee43e41382689880ea6124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cbebefb06eb1cf524a75a605d36d98d1b7435f2bf116ba9d40e78d743918f3b"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
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
