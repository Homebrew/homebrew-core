class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/2.0.4.tar.gz"
  sha256 "b401664363020474869a81a70d6920a3bfacec12459a601d8f9a7627000dfb56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c50249da637ab9fbf4541fd0294a1b0a5d7d09c0f99e6dcad7950abde848fb71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "794d2e4e379ebbca544e4f7a7b119fe0e8f51299e8f23bcb9b199a1aa89ef187"
    sha256 cellar: :any_skip_relocation, monterey:       "390fa091d14e16661bde506a27bbf75933010a5eb1ef5d912690ebce1dc4468a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6bb75fdd97e9d94ab912591b644ec2548dbb574cbafc5dae9ed8ebbceb202df"
    sha256 cellar: :any_skip_relocation, catalina:       "125d44d48c49c9abd3b5d5de9e7e4d203af141da3eb77fb316a2dcfc13988a3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e651925757f84dbc6beb86b1f252b2047dc0eebdbdbf9ee36248a45c069cf2d"
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
