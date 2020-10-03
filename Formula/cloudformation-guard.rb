class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/1.0.0.tar.gz"
  sha256 "1d4c057a9c076f0311409603291dadad0063159a8bed6b5576accec2dc3a4e7b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d1af2c3d59f5a87feb0d86d51538c4a300c8c37fdce88faa668d63e42b67492" => :catalina
    sha256 "5a3af034fb1c5c4729a2c1043e032d156531ade94a56f88349df32e43f340be0" => :mojave
    sha256 "1d97514ed0c474825c6c0b334fa546f8dfbab107031d435b4325e523b46e5de9" => :high_sierra
  end

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
