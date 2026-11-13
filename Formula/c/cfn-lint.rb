class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/a9/9c/114b3e8bab54caa706ad9294982499f4d86e84d041953904e5ce5c4e72e6/cfn_lint-1.60.1.tar.gz"
  sha256 "d07d50f0f60b5c719ed3ddcd06ab7329209f74892a14e1e853c49fe4d4bb5dce"
  license "MIT-0"
  head "https://github.com/aws-cloudformation/cfn-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d7b31517bd1617b550b39c51a944f0037998fa55f4007e1f1894eb89065f3e44"
    sha256 cellar: :any, arm64_tahoe:       "964d4da9df339f3506f47cedcd719a60a28d8240f4fbe51082ee96a22de33b8a"
    sha256 cellar: :any, arm64_sequoia:     "fd3c869d3cb0417d0fbf8efb4ca82adfcf3dcc4968d80c6325c2495cee0b1de7"
    sha256 cellar: :any, arm64_linux:       "e1aad56d0868d535d744cbd53fe95b13ba45202b166c476ee5df83fb81bda95e"
    sha256 cellar: :any, x86_64_linux:      "bbfae1535a950baa2a326572c3df2bb1d6bef02dff39b1a87afd655c79e157a9"
  end

  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: %w[pydantic rpds-py]

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/8f/13/43ae689f9340dc7339dc7f5a3b1772edcd48fb1eb62fd5d801a2aa09d382/jsonpatch-1.47.tar.gz"
    sha256 "5ed650b7517789e0f43428aa7b09442c0b90de0a0fd17a53fd0ebf55205c601e"
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
    url "https://files.pythonhosted.org/packages/61/27/a5afeb952577b84ee5fe48b8b9ce47ae662dbb69cc5b76c28eff98f83b1e/regex-2026.11.9.tar.gz"
    sha256 "316a70fbd70e999c9664681cb0eb5b4982b2cc0f623c7c86a8a112e1bd4c6277"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/83/d3/803453b36afefb7c2bb238361cd4ae6125a569b4db67cd9e79846ba2d68c/sympy-1.14.0.tar.gz"
    sha256 "d3d3fe8df1e5a0b42f0e7bdf50541697dbe7d23746e894990c030e2b05e72517"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

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
