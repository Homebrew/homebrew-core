class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/2.0.2.tar.gz"
  sha256 "2db0a5ca0d68b05747b2a6ca07129e38f1825c3cd034b9ed393214a47c94a437"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cfae801ef1fa761b9a680003aab842dd144547cf1545a8edfe0ef89308d608a0"
    sha256 cellar: :any_skip_relocation, big_sur:       "b4a4261ff5d1cb01a57952e0a708a82db9f4b0a20a2058f99fbd00eeeb285ef5"
    sha256 cellar: :any_skip_relocation, catalina:      "51f2da33dfa429ac853feb9fc6122d7ff402c8bbd1e4e0ad7729e9a0dbff9a68"
    sha256 cellar: :any_skip_relocation, mojave:        "b8bf78098c262aaeccba2b574925e6539fd78174a1dcfd7d27d2810952558ea9"
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
