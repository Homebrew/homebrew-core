class CfnFlip < Formula
  include Language::Python::Virtualenv

  desc "Convert AWS CloudFormation templates between JSON and YAML formats"
  homepage "https://github.com/awslabs/aws-cfn-template-flip"
  url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
  sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74bf24bbe2143370918782c493b21b39abc6257e0ebd307e42ebd15fe8511824"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74bf24bbe2143370918782c493b21b39abc6257e0ebd307e42ebd15fe8511824"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74bf24bbe2143370918782c493b21b39abc6257e0ebd307e42ebd15fe8511824"
    sha256 cellar: :any_skip_relocation, ventura:        "703b9ce40aa1b8cab19e85ce08e228d949d13af32512af0984af022ca9e0c93c"
    sha256 cellar: :any_skip_relocation, monterey:       "703b9ce40aa1b8cab19e85ce08e228d949d13af32512af0984af022ca9e0c93c"
    sha256 cellar: :any_skip_relocation, big_sur:        "703b9ce40aa1b8cab19e85ce08e228d949d13af32512af0984af022ca9e0c93c"
    sha256 cellar: :any_skip_relocation, catalina:       "703b9ce40aa1b8cab19e85ce08e228d949d13af32512af0984af022ca9e0c93c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "362d11490de8c297b78c382109f617f09beb4f8c38f40204923744844a1e1704"
  end

  depends_on "python@3.11"
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
