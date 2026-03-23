class CfnFlip < Formula
  include Language::Python::Virtualenv

  desc "Convert AWS CloudFormation templates between JSON and YAML formats"
  homepage "https://github.com/awslabs/aws-cfn-template-flip"
  url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
  sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_tahoe:   "91cf666b7be505945d1297f00adaae08f845a5949371a5575a3b6f05877bdd47"
    sha256 cellar: :any,                 arm64_sequoia: "beb6acb08ffbc695cd400c5fce04973519ba0cf0521562134de52d76c2a6a8d1"
    sha256 cellar: :any,                 arm64_sonoma:  "b1c4ca4f9eb9015da077c27998e7b4e4406607566eb1a366327cb4d65b9700f5"
    sha256 cellar: :any,                 sonoma:        "50abc0dcca0ad672acefca8f38926dbe775070472bb28b96f4d899755399256f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fc33742bd230258121b4e247daea5aec24567465769ab928f4fcb270630cd7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aa60a3fda02c52177a0b6497ba0c7e35a00972d0126a9f78bd2ac179893d22c"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
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
