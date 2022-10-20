class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/2.1.0.tar.gz"
  sha256 "8e7075e436a05d72e5c244def9765f475c07b97b432c6ed9b4cc9888a389f460"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e679636e6f6dfb96f827f0859eca3e2482de67ac499322fbdef1b11d8c4a8c32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64582c694ac3f8f621a4bbb11c63873d5a17c807d59cbe4fc2a5804d534ac218"
    sha256 cellar: :any_skip_relocation, monterey:       "54c9a9abda8ba5b06f41cf21698cc68c7dad8f0ea6f4810439186b3067a6c6a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "edefb6434aec409b1192861be0ef1d3f29c63a559ca6130ed2d2b9c5f49bd169"
    sha256 cellar: :any_skip_relocation, catalina:       "9313f1eb7e774214cccbf541b72d050f4102d2e1cec9981b02d33e4068d2ba65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0ec1413420eabab58c7881b1204bc49976c797789b60bd93415bf16cbeb40e5"
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
