class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/refs/tags/3.2.0.tar.gz"
  sha256 "55327efeaf1b022815e92437a546157b00caa3017d70a20b33ba1e7ca2181c54"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9fb34acc786d34e3fea5a65f1247b839c12fe80b8094d2345aef10f38e25be2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b05179631ee4c2966763c043bc0ea9ea613434605753e02ae121ba7a64ff4db2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e9bd81d7cdd41cadc72b376f4d56f3ad6372261fcc3ed3c2cbfb9a63af584c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5fbcfe68ca3437637d3026d161ddec4fc92067285c42a8acacf17159851f590"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e7f63073241eb277f8e9a250989af79c15519fe89cdbacf2a05e6a1b2ebd745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d52af0ecca251ad205a93a59fbdbffe71f6d1eb72aa2f7be69fb27ed04559a16"
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
