class CfnFlip < Formula
  include Language::Python::Virtualenv

  desc "Convert AWS CloudFormation templates between JSON and YAML formats"
  homepage "https://github.com/awslabs/aws-cfn-template-flip"
  url "https://files.pythonhosted.org/packages/76/5a/314a934b75f2f52d1845e4344b9bbdacdd76d82784b678ec27c2ed57fd2c/cfn_flip-1.2.3.tar.gz"
  sha256 "2bed32a1f4dca26dc64178d52511fd4ef778b5ccbcf32559cac884ace75bde6a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e839991d90501ef68afcec82bd4445dcf24242b33a31bd5ebf3004799e81512" => :big_sur
    sha256 "c697eb2c6521e79bbdf5a834866914b9316383789a8ac885d7f1439b2c2774d2" => :arm64_big_sur
    sha256 "e0f813ad41397d94b167cbcae814862abf436cd46b0996f83da0dae5e3d6d717" => :catalina
    sha256 "d22cab76b33a3b6b836aa723242befc46fb8028fe282af1d4ccee64e4a21165a" => :mojave
    sha256 "29ecc4856f9b64362498cf82765cef635f7b12f6b8570a19f5c223ca007a4e0c" => :high_sierra
  end

  depends_on "python@3.9"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
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
