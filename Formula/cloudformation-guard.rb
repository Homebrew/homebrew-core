class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/2.1.1.tar.gz"
  sha256 "c4ec929c4f17ed964c31310b68904489de2eb1a522cc00df88352a736da52958"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b67a7fdbd036ebfb6b282f084feb0cd6ab75b31ce461bd76b626bb363e9b0a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcd08535d7f5f436aef23e6b7cc49e7559b5d57e0bf0968a9e82bd74fd3e54f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a1a66220c025da2bdeb2ce3d7feb177c513652c82db1547e4e1cf21a6de9ec9"
    sha256 cellar: :any_skip_relocation, monterey:       "74b5bbe5aaf422974eb0ef586edf27d15f5189e0f4027bfd434d239ef3c0662e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4ea6040c0f8e95e26fad87cb80e52274d3d5dc2b644d111c6d4954a742f9cc9"
    sha256 cellar: :any_skip_relocation, catalina:       "6f0d0a0dfba89597c71af8ed68ddc451fa9f028f50c0707a5c314c86466dd48d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed7bdd2edd44240c2a844b6d1552f9413bab1b01020c0ac250a953d94c5da4a5"
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
