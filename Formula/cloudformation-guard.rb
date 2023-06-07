class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/2.1.3.tar.gz"
  sha256 "ea3b6fd1ec306a7c9906a4d47c438a875a3a635ec7a458057d4b6d5cab71d0f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abcc600f7f52302d5b0f06c1de2dbbc0115f121a564304e34e5495d5e0c08279"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0905a205abc9badc4e0d7f587ed3e72e46239356d62995906ffd32af2666393e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf565a776a566117ab5d9db04d3454c34d065272e63fb544328122ef76e98c53"
    sha256 cellar: :any_skip_relocation, ventura:        "33cfc74bc7e4660a2b71ba8567d5eb39653bf636a540a2a7f413d83a85d40267"
    sha256 cellar: :any_skip_relocation, monterey:       "b41bff35e06b2e4521ba3031f118e874b2e524da31bd7521a49f52f05dc45f1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a0b436b6d4085bd16e2e0283bf718a5b673517adf2e9bd308c4e3fabaf04b41"
    sha256 cellar: :any_skip_relocation, catalina:       "792e7e6c0ba66aa5164440d8162f9ecba009e4ad02c6afe55c21bfdf60bdc86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14b22063b5279abce3ce05d65732eb981815520f777de1271ecab359a8ce9a7c"
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
