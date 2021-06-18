class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/2.0.2.tar.gz"
  sha256 "2db0a5ca0d68b05747b2a6ca07129e38f1825c3cd034b9ed393214a47c94a437"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7c43d1e9cce5d3aa581a9060e442e65f889593426f59c3cd10b7daff7ef1eb28"
    sha256 cellar: :any_skip_relocation, big_sur:       "c9f566d3b02500d89fe7782547ad4661dd9cdd0db90cb8f742183220af1801d2"
    sha256 cellar: :any_skip_relocation, catalina:      "97f0bf373f9cc106660bbff1f8e3aac3e86906b15d11633788520b6670f44eb9"
    sha256 cellar: :any_skip_relocation, mojave:        "8b485665e86453b38df8baa6c0715b53aca87129128878384fd62652cf04cacf"
  end

  depends_on "rust" => :build

  def install
    cd "guard" do
      system "cargo", "install", *std_cargo_args
    end
    doc.install "docs"
    doc.install "guard-examples"
  end

  test do
    (testpath/"test-template.yml").write <<~EOS
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
    EOS

    (testpath/"test-ruleset").write <<~EOS
      rule migrated_rules {
        let aws_ec2_volume = Resources.*[ Type == "AWS::EC2::Volume" ]
        %aws_ec2_volume.Properties.Size == 99
      }
    EOS
    system bin/"cfn-guard", "validate", "-r", "test-ruleset", "-d", "test-template.yml"
  end
end
