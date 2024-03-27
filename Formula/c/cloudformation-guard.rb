class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/refs/tags/3.1.0.tar.gz"
  sha256 "bfe75a97cdc007ed481ee472db90e0baf2cd814ac29a629196713f109d07d747"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6911dbef3e79167d65d7ff3fdb71a6e7e2fd285f45d4612753749adfb0a7f42d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26ec3f8e3ae69d2709b22702be582ea15b36d7d004efbebd11ba065dbc15e738"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c54ee14a4dc941dc6dd97b877da27235682cd8b7eafd2590bea030076ddc9ac9"
    sha256 cellar: :any_skip_relocation, sonoma:         "e40351ed4aa408431a3b5f87058e0e8d9143a3c0cdaa4df10ac4be38d388c86a"
    sha256 cellar: :any_skip_relocation, ventura:        "58837f0f32582af547ddc23ff15af5a78e94c286b9551ad1da4d024be116439f"
    sha256 cellar: :any_skip_relocation, monterey:       "de12863419b5bf1a288739550c69e769063ce24aa1a96412e09326ef5193a903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5791a79c1199f06005cdb26522fc8974fcade737b6c46c9a2e80ff3de475582f"
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
