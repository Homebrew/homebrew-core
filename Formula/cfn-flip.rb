class CfnFlip < Formula
  include Language::Python::Virtualenv

  desc "Convert AWS CloudFormation templates between JSON and YAML formats"
  homepage "https://github.com/awslabs/aws-cfn-template-flip"
  url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
  sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62ce1d4aaafd2b6c0baf9e899baf1354ae375e8810fb119e0f33e59d98dd42dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c30e20ba1e20a93f6c4e0cb15b76f2c7cbd9cf65d0bc4865d933d3a6c8d16aa4"
    sha256 cellar: :any_skip_relocation, monterey:       "dde77b69e0bce0d7e720dbeb50ecca04adbba5c7b20dec92f07dbb27b07c379a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2fc754ceec0d6bd7964c67c025dd6194396b3c5a8b7e857cffceb80d1d540869"
    sha256 cellar: :any_skip_relocation, catalina:       "173f26ac0f8cdd2e87e3555dbbab76c30b674b949a07bf27b5b8fe6ffbb406d7"
    sha256 cellar: :any_skip_relocation, mojave:         "49d83ff2732db641922de273119a56b99d286ef95b489a96a06cd509b004c65d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1956e8bde147547f9b1812bf32964d1f22dd7c512fca7b0ba23c4cadaad31cb4"
  end

  depends_on "python@3.10"

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
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
