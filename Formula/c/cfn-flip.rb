class CfnFlip < Formula
  include Language::Python::Virtualenv

  desc "Convert AWS CloudFormation templates between JSON and YAML formats"
  homepage "https://github.com/awslabs/aws-cfn-template-flip"
  url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
  sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  license "Apache-2.0"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "285b23f6575697d3337439c12f1374971ed984a6db8d5ac82db5e3d47472b3d0"
    sha256 cellar: :any, arm64_tahoe:       "9d6f560031fc7d9591e99237b9e1748e02838f2c445cfe883e9445f2f097accf"
    sha256 cellar: :any, arm64_sequoia:     "4230ca900cc6879b12da87ee796fa23d5805fb1eee5b67749e7391cde74d7209"
    sha256 cellar: :any, arm64_linux:       "95db17a9c176c0e3ec3cc20bdf7817de282154c3676b9b80539473252f7a09d6"
    sha256 cellar: :any, x86_64_linux:      "d24ec893ad702667bae0bb8e03f04146517c1f3777388a37ccd1292845929b01"
  end

  deprecate! date: "2026-07-17", because: :deprecated_upstream, replacement_formula: "rain"
  disable! date: "2027-01-17", because: :deprecated_upstream, replacement_formula: "rain"

  depends_on "libyaml"
  depends_on "python@3.15"

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
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
