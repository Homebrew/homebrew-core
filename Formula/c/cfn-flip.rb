class CfnFlip < Formula
  include Language::Python::Virtualenv

  desc "Convert AWS CloudFormation templates between JSON and YAML formats"
  homepage "https://github.com/awslabs/aws-cfn-template-flip"
  url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
  sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "07d7a01e5e4b2cf04a12cf05b6255c452326347afc72cf22c755f11eee638fac"
    sha256 cellar: :any,                 arm64_sonoma:  "a30142eaa1b55eacf35e1c2573e38e516779882086ddb7c417e7bee97e556f5c"
    sha256 cellar: :any,                 arm64_ventura: "21a22fd0985168ca5c0ac5836ca4a85928d159833fdd4e75553e9295b8e74514"
    sha256 cellar: :any,                 sonoma:        "c1497cca44686eab9b0031d34deab63258a1d891c7f8854e39558c7c60f01f96"
    sha256 cellar: :any,                 ventura:       "92e08c7a0fb66b3c691bf141fac782213907d85989945519e1dc1aa55bb686a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a009e9b1951f2f55ff9891c6e3366a2a66a2599f211f75ee420274f7b1ed811"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cfn-flip", shells: [:fish, :zsh], shell_parameter_format: :click)
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
