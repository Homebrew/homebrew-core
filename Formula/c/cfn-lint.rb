class CfnLint < Formula
  include Language::Python::Virtualenv

  desc "Validate CloudFormation templates against the CloudFormation spec"
  homepage "https://github.com/aws-cloudformation/cfn-lint/"
  url "https://files.pythonhosted.org/packages/c3/ec/3b58d77e21b0283aa9887f4c3f81aeaf3a839111f2ebabb34443c1c76f65/cfn_lint-1.60.0.tar.gz"
  sha256 "8c12142205cdba8b63236cc6e61f06aff6b563ae957c83af76e56940a3a4fe6a"
  license "MIT-0"
  head "https://github.com/aws-cloudformation/cfn-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cf968eb2d9cd12afe4a4eef8413d605bbc171ce902774e8dd6d906b71eb4f082"
    sha256 cellar: :any, arm64_tahoe:       "2a41233ae949f5bf3b558787e5ed5a60dabb884c1fe51737c15febf2602fc56a"
    sha256 cellar: :any, arm64_sequoia:     "4ad28bee09facdc0091d44119fb0ff3dad3f0c0c24daac225864d3e7c2a1991e"
    sha256 cellar: :any, arm64_linux:       "b85587737e0ddf0b63ac8ddef696fb9784c659b7a3b11a7915966cca1dec9ced"
    sha256 cellar: :any, x86_64_linux:      "46b7c5da72ed64de5c85d1e64cb1702ea3f186726392344adfdcd05ff71663b2"
  end

  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: %w[pydantic rpds-py]

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/63/d2/b8e85a5c18344f2885dffa0eef881617540000bb10212939e7b5e4b9e650/jsonpatch-1.43.tar.gz"
    sha256 "0dbd831e9853e4ec9a3897a9cca87716533d2c05f8b5ca0f6cde70d83e5758b6"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/43/a1/33557aa08bb76a1d639db700b65b1aeb3ff10bece6da7bf034edf0262fc2/jsonpointer-3.9.tar.gz"
    sha256 "b4c52dd58837669881f9677c0e83d73fa0b369feb67563ec4a8b1c13eb3c5a23"
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
    url "https://files.pythonhosted.org/packages/fc/f2/af1da9d3ceed77bfcdce40427d49ba0be94e4fe84245e3bfef68c10e75b6/regex-2026.9.29.tar.gz"
    sha256 "8b5fcc4771732191b2b7d1dd68d8f0353f47f8d90b6150f6dce58bf1112442cb"
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
