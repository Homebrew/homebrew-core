class CfnFlip < Formula
  include Language::Python::Virtualenv

  desc "Convert AWS CloudFormation templates between JSON and YAML formats"
  homepage "https://github.com/awslabs/aws-cfn-template-flip"
  url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
  sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07635ad295b8fe2e56b40c08da7fa0fb63236d0ddf2b7a14a8fa19ff05bc2b92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07635ad295b8fe2e56b40c08da7fa0fb63236d0ddf2b7a14a8fa19ff05bc2b92"
    sha256 cellar: :any_skip_relocation, monterey:       "b25967c3596d71bb9b4a25c9047b60797c7e721a2c24d010d04be71a9b55bec4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b25967c3596d71bb9b4a25c9047b60797c7e721a2c24d010d04be71a9b55bec4"
    sha256 cellar: :any_skip_relocation, catalina:       "b25967c3596d71bb9b4a25c9047b60797c7e721a2c24d010d04be71a9b55bec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0ac941e7d38918f5980a989113f55dc0a89bfccf4c8528b55e7bd0c9d74df05"
  end

  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
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
