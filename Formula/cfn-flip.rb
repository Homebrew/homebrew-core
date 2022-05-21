class CfnFlip < Formula
  include Language::Python::Virtualenv

  desc "Convert AWS CloudFormation templates between JSON and YAML formats"
  homepage "https://github.com/awslabs/aws-cfn-template-flip"
  url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
  sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  license "Apache-2.0"
  revision 1

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
