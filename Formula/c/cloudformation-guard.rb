class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/refs/tags/3.2.1.tar.gz"
  sha256 "9d5a2e73b70f854be721db20cc3910852fd95b41910a620ab770382543e04d68"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3746629a8b754f7bb9679603070331d68dd02695fdaed375b7cf8138f3f4bc0a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b53da47df79793f467a907af4f160f6067cb945a358c1f0cdcdaa14fc2c7162d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc314e664ba9696aa368da7d2ca298bc399008ed003347c42cee4a5fc2a72096"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "49d51e445ee668338381236e168f2212a9e606ac0ee38767029cf5aa5f3ffa12"
    sha256 cellar: :any_skip_relocation, sonoma:            "874d4007af533663849e8f6724fb7042d19efbd7aed12b3f23a5bdc6b577da7a"
    sha256 cellar: :any,                 arm64_linux:       "895ade9c8af94ed6fe4f5c2c935a411aab76ae0765a005ef15980bf7905f7350"
    sha256 cellar: :any,                 x86_64_linux:      "a4d1747b0232d4e19f6cfa1b21032c20bf5093953c274fec3173574612b2f7e5"
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
