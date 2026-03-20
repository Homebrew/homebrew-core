class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/refs/tags/3.2.0.tar.gz"
  sha256 "addb41aaa0a5c262aeee6eee662e4f4f04cca6765615305a3ec219df61bb252e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afbeeccd08ce9e9478104a3299b1df72d8a9688afd03258de24526a615555e23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52ca90a6b15772b4b29e46a31f462439503064fdf5b1d820e925450053433530"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02f8375e0269f0033e96ec35fd54c747be2432adf3b51fee9347f96e73d1db74"
    sha256 cellar: :any_skip_relocation, sonoma:        "71dea79d22078b7ff7d3c3eaf20e367ba3e6bb3dc6eeb1cf3d3186d65ac59a4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "670bec81b31d1b0d6d07833109d9b17258167923b8ad1adc1a4bcffca831c322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e83c9e7e45a54ba52a14857ac3b3ea0e33fae54534d467c12a568d60c7367bea"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "guard")

    generate_completions_from_executable(bin/"cfn-guard", "completions", "--shell")

    doc.install "docs"
    doc.install "guard-examples"
  end

  test do
    (testpath/"test-template.yml").write <<~YAML
      ---
      AWSTemplateFormatVersion: '2010-09-09'
      Resources:
        # Helps tests map resource types
        Volume:
          Type: "AWS::EC2::Volume"
          Properties:
            Size : 99
            Encrypted: true,
            AvailabilityZone : us-east-1b
    YAML

    (testpath/"test-ruleset").write <<~EOS
      rule migrated_rules {
        let aws_ec2_volume = Resources.*[ Type == "AWS::EC2::Volume" ]
        %aws_ec2_volume.Properties.Size == 99
      }
    EOS
    system bin/"cfn-guard", "validate", "-r", "test-ruleset", "-d", "test-template.yml"
  end
end
