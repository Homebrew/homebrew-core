class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/2.0.3.tar.gz"
  sha256 "a3bcd94d679cef01db21a2daa6b7042f9fbb3dd56388318ea534103c14c96930"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "68ceb64498c4b499e1c5b9d8855a884a0ac4f389476d5bf6da0f151378c1ad4c"
    sha256 cellar: :any_skip_relocation, big_sur:       "f8a125c4de3fc9e921df68c0ac957b785de73ea8e815d1fc0ea2cced5dfef881"
    sha256 cellar: :any_skip_relocation, catalina:      "36b146ca21768e8aaef9c1b10d291488f5a776dabdb02a690107ab1d8383ce67"
    sha256 cellar: :any_skip_relocation, mojave:        "c7e5b37de4696d225b5c550d2a82e9f48f1f726fce5d7af531a2d38f55eaad3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aceecc8eed7f44f26787420ded0984f8cd18ce01a90ce15b3878c00ba4af71f0"
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
