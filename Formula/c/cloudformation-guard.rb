class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/3.0.0.tar.gz"
  sha256 "ce0f06bc4d632dc64514f24be40de48e53e8cc97e5cfb2434bb84811ceecb899"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4b932da57b9f98e1fd1066023304f158173802caa59f73f26345f7ff05a002f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "debacf0ef2617f8763477c40106667cdcfebad24291eaa08f00e46f5b77ccd2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e09df565fe59c4fce234400410154ea9720a00db269e5c205750630d2d9bc625"
    sha256 cellar: :any_skip_relocation, ventura:        "404d4fa9ced07bdb78bda263ca068a680a707e29cb42b3f1be26195e148936b0"
    sha256 cellar: :any_skip_relocation, monterey:       "7fce5c94eda4eb8e0df34cc7689a9dc977cdf99abbdebfda38e380fe18f75d92"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecc5e7afe59910f18be0889d72d914070fdcde884a71c6f175d7f275ca60d70d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6366af9ff59aa85361325da05614a601e3daa65bbf754d4d1d477fe80cc874b7"
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
