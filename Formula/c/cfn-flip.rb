class CfnFlip < Formula
  include Language::Python::Virtualenv

  desc "Convert AWS CloudFormation templates between JSON and YAML formats"
  homepage "https://github.com/awslabs/aws-cfn-template-flip"
  url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
  sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfa8ad344050b051403b4e0e17b16e727c23b31e053b344efa306ca1b4c5dc13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7fbb6d7209b9ea5d7d80515f120ad7f2202cef042b4991e4b569ed7f48c6548"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1f83c3d97daf47b758ebe6055d49715208911ac59e49d2f962641eaae21b406"
    sha256 cellar: :any_skip_relocation, sonoma:         "52d100482291788d00bf2514cb5bb39339fc6add1872a5d348297e099614875c"
    sha256 cellar: :any_skip_relocation, ventura:        "25467adf968cf84863633dcc0f4214a704b57457d523979b08ceca02287dbd65"
    sha256 cellar: :any_skip_relocation, monterey:       "792758b0485219c76a998bc0e59a32a824b6d1477b7c26e243ee1e64ab44217c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea89f0b93ab362a699c81b6663f8d79749a824d445d9a32630490d960d311816"
  end

  depends_on "python-click"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

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
