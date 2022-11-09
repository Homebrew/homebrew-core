class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/2.1.2.tar.gz"
  sha256 "271e62e72f0e20f46945af7f57c5ee1b79073e16e36b3cbea155691963b82370"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1abbd4816175194766d76488f11807845b048e51c1e6c94bdaf37c17a7671b1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78c5fb7426d3ab811e942ac02ad93acb196d76703a4564da4ad9414c405c8d79"
    sha256 cellar: :any_skip_relocation, monterey:       "64285eac8e11b85748bb986407331bdee3acfa13e9c0fa2e43f77f4d0f4bce4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a9e161b822968e4a6c2d78db89188d17ce8e1fd3780458e434940a43f6c5d7c"
    sha256 cellar: :any_skip_relocation, catalina:       "f1173a1031b85cc85625e4f2d198cd963a8ff1828ced54f82d29e5c7393e3fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca462d52c18180d088086bd3f3c4526e204c81c24a1b178a1ad0e9de0d561723"
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
