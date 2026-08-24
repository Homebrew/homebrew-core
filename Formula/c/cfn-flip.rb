class CfnFlip < Formula
  include Language::Python::Virtualenv

  desc "Convert AWS CloudFormation templates between JSON and YAML formats"
  homepage "https://github.com/awslabs/aws-cfn-template-flip"
  url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
  sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d1306b16bb259f471bb5b2e80b4707c3bc04cba757306d353363e24a004c858a"
    sha256 cellar: :any, arm64_sequoia: "ab5f9212ee1b15e48f2ea3326c8d6e1297f804f216994277a6bc7c93fff12111"
    sha256 cellar: :any, arm64_sonoma:  "d45ad504e83289265b246cafa40c3d1e8f69c7f79c172603851f87319bd958a4"
    sha256 cellar: :any, sonoma:        "35b3551a30a2ecf7793cb5a7ab58558142b7196b01d4446f4a31e3c039f6afd6"
    sha256 cellar: :any, arm64_linux:   "87c95cb7cc5b1fd91015a2bc099e90557f690abafdc1a4a4a7589fbd6ca6b4d7"
    sha256 cellar: :any, x86_64_linux:  "a790d632f4cc2eb04499499df83fe4b804b4a4187e7cfbc20df5e80e262ec69b"
  end

  deprecate! date: "2026-07-17", because: :deprecated_upstream, replacement_formula: "rain"
  disable! date: "2027-01-17", because: :deprecated_upstream, replacement_formula: "rain"

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cfn-flip", shell_parameter_format: :click)
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
