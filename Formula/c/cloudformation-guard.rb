class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/refs/tags/3.2.2.tar.gz"
  sha256 "9f85f251684affe611ee3850d458054befa65e4517099701e555f001e3dca938"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "742ab07595589d4efb667a0dba9379cbff94c932924e7dd4bc65b13eefdc565e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "235b0354d27932867da21c76429e4ba6715c2c34107027faadfbc2b0222bb344"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4f6f777a9e706c56b021940991c7a69cae898a8c3a62b3944b65119e3b534646"
    sha256 cellar: :any,                 arm64_linux:       "224ad47940ceba6a38ed345bbea7d358e210dd2a8776dee080ddbc074ad69821"
    sha256 cellar: :any,                 x86_64_linux:      "6c93ee3070cfd3fbb2e5022c79b715afd28ce3c55953f1b951b1f22edb8779b4"
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
