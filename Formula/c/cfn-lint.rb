class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/9a/cd/82bc68b69eb8a1a6a09a88ad6a0b54e1990ea127665e4c9faa8b1ea0f4c9/cfn_lint-1.61.0.tar.gz"
  sha256 "a408e1ae0a059b1e8cdcd581c01545ebc99a40961e2edd2a1c0a77e463dcc922"
  license "MIT-0"
  head "https://github.com/aws-cloudformation/cfn-lint.git", branch: "main"

  bottle do
    manifest_sha256 "5737220b94106378fe30021674e00bce394adb71a3d305de4d866bef6b3de93a"
    sha256 cellar: :any, arm64_golden_gate: "9955380793f715d119961a1857da94cb99512c5efc6d2f79c64d22566c2d877b"
    sha256 cellar: :any, arm64_tahoe:       "20aecca0d817538ac54ab963c5e276f0a738a88633d7b1723000284479c252f7"
    sha256 cellar: :any, arm64_sequoia:     "e57666afed6b4c1c827d6c4866262a81e2b8e214313387ba3276b327ed5d5b1f"
    sha256 cellar: :any, arm64_linux:       "36e13587793d5ab25c1bd054221796f2b6168e6e76c0cba4049b8040937e2bd7"
    sha256 cellar: :any, x86_64_linux:      "2d0e6f308b9b7496fde8a621df0d8ee69b3d302caef730a6d1ec1ef9a55df220"
  end

  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: %w[pydantic rpds-py]

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/9c/b5/0236966b8a3d5b9bf147ea81932c0cd59358a77497bdb95d137e5ee3f080/jsonpatch-1.48.tar.gz"
    sha256 "81e9a03754137a1201d9b534ddd599cc0eb5983fe941bce238dc8a76e442bb94"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/46/cb/2c3112a061a718d93866c2555dad1e9d53865e4703d0f3be550d252b277b/jsonpointer-3.12.tar.gz"
    sha256 "7a3dcc11b64053eaa9c549e85e413f8d40a075215f793a331bed9182a14251ae"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/dc/76/3af777226b63a5e64a6b36b1ec5855c14e2b94a37096d4760e595fc43511/networkx-3.7.tar.gz"
    sha256 "fd77a511bd90f39f3d016351345b52cf5319b813bdca01de3f755d3cca62e96a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b8/17/ef8c46a9e7cf2304968eb260f594bbd4220fab6281e64c090cdd85884511/regex-2026.11.19.tar.gz"
    sha256 "2826a006b68acfd3ed5074433caafe21d7f9d026eb82cb856724a4a893a70915"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/83/d3/803453b36afefb7c2bb238361cd4ae6125a569b4db67cd9e79846ba2d68c/sympy-1.14.0.tar.gz"
    sha256 "d3d3fe8df1e5a0b42f0e7bdf50541697dbe7d23746e894990c030e2b05e72517"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  allow_network_access! :build

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cfn-lint --version")

    (testpath/"test.yml").write <<~YAML
      ---
      AWSTemplateFormatVersion: '2010-09-09'
      Resources:
        # Helps tests map resource types
        IamPipeline:
          Type: "AWS::CloudFormation::Stack"
          Properties:
            TemplateURL: !Sub 'https://s3.${AWS::Region}.amazonaws.com/bucket-dne-${AWS::Region}/${AWS::AccountId}/pipeline.yaml'
            Parameters:
              DeploymentName: iam-pipeline
              Deploy: 'auto'
    YAML
    system bin/"cfn-lint", "test.yml"
  end
end
