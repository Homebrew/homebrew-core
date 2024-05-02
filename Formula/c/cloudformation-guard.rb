class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/refs/tags/3.1.1.tar.gz"
  sha256 "ee870572b4b5e943a42c452c755c7a8af49675794b738051b8a63aa284695276"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e85551c6efc0bc9749403de993f0e2cfee43c1e0839cafecddf797f92210ed90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1f9b0163980146193564d347e7f042c226850c9518f931edeb350c0645c4c3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6baf6f0deb18323592252b17316589062dce7fe54296b6f2827b68c6629231e"
    sha256 cellar: :any_skip_relocation, sonoma:         "92ede39ca7745763c47da6c9a6da61084b5d7a7c6b3e5e07c135fd286794e359"
    sha256 cellar: :any_skip_relocation, ventura:        "ae8ea3e6f9295868eaec3c63e409739c900d69d956753aa92ce47e3331a31d08"
    sha256 cellar: :any_skip_relocation, monterey:       "6f64bcc66ef1c0c0db113aa215b6c8ba0c8e1f34f0709788347df54105618726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36c2a82c1b64b8bbaac3fea7c446f8cbccdfb39e3b6aae5a47b8e8d03280b139"
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
