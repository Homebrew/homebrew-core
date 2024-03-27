class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/refs/tags/3.1.0.tar.gz"
  sha256 "bfe75a97cdc007ed481ee472db90e0baf2cd814ac29a629196713f109d07d747"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f04e9016bd5e469b400d9dd26d719249f5685425974bac4cbee1682216fb2a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f10190b2966c6e27a1a6fe77726c1c72035b6ea340bd38f9a17c3c7713d60d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67f006acd7a2730e17ec7cc61cb4edf38f9bda7d3d924d091a06404f21922ebd"
    sha256 cellar: :any_skip_relocation, sonoma:         "7cfe35a0fa4257187ac151d1a47360a346dc9287a230fb68ceca0896d4d24e5b"
    sha256 cellar: :any_skip_relocation, ventura:        "85591b511f1ed9e3fa0153f3748126a5bdddab4996137a8f1357c0bfdf381d99"
    sha256 cellar: :any_skip_relocation, monterey:       "f330c909451cb53ca01984da486702b33115644ccb275f2afbbdd2355b17e1a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8bbc703526de95a0475b87b9b4d01322836dd01f4f5ebbb2c3e738ba29b5631"
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
