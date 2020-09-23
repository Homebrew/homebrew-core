class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/v0.7.0.tar.gz"
  sha256 "f285c76ca32ca671380f254d0ce01dc6e5e3d91ef7d6e4c7fc2d6abeb7520e79"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    cd "cfn-guard" do
      system "cargo", "install", *std_cargo_args
    end
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
      AWS::EC2::Volume Size == 99
    EOS
    system "#{bin}/cfn-guard", "check", "-r", "test-ruleset", "-t", "test-template.yml"
  end
end
