class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/3.0.1.tar.gz"
  sha256 "4f58b104549f2c3ffbb98ca95481b062bf35fad96334a0a3310c37d0bc3fbe56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f58223bdb7a7fcecfcf30495978227236a0239e07a2d15c4949d762356b2aedd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12eb2292ac8773a22570e0da138cc799fe3b044baae1588ccfd855bbe8b453b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13df5d690591561495cfd4d76c8124cf3bb8dcb8869f1347df8f442875fa8b3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0635ed92f0df574cae34680e1ac8ce3405556c90a00661c70248a266402d861a"
    sha256 cellar: :any_skip_relocation, sonoma:         "86b2d434e53094e51259c9ed26be4a0ffa97b784a40091bb410e575d11751098"
    sha256 cellar: :any_skip_relocation, ventura:        "6f35f39a241df3772ca9d4c8b05cf5c9138050238a42be26cdf5c029e09a9b10"
    sha256 cellar: :any_skip_relocation, monterey:       "f914feeb425079153c88cb31bb1c56c2fc6a8d5cedb3d156fda37f3516130a84"
    sha256 cellar: :any_skip_relocation, big_sur:        "69bd2b278a0736e06fdb14ddb2a3e03ca7d162ac03ff0e8ae9969cbe46b2161d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0c698cf23e21a2105cde05ebb22a65a585ab8f92511ef21e9f50151f1516ab3"
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
