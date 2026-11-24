class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/refs/tags/3.4.0.tar.gz"
  sha256 "bf81fdf32225778195af11202290ac0a71072f85abe902be47d20b3db49f8da8"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "8084ba355cc4c909653a1fcf0e95626da3347b701b316314090b4f36bb83cf8d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3ef8170d96069cb28b78d7917bc43212c362c52d9f938fafd785bf8718d33daa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26241f0afca799bfb64d7ad59c65e8fb3c900ee1e1e5d73380972be61276d385"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "668569ba13b78f05582aaebc5295e65142985b73b4b5a123c528adb6dd1cc591"
    sha256 cellar: :any,                 arm64_linux:       "5e6d7ff18a72d2100c9d5ee3a6969c7a02eadbea09cf1bb1d3b34336d5d9a813"
    sha256 cellar: :any,                 x86_64_linux:      "673e5b68677f5d916664156d4db414d2959b2aadec7f483d5dc129cdd90cb547"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
