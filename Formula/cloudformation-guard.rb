class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/2.1.4.tar.gz"
  sha256 "f699cfae290c86e0d98745caf18acfd4198b73117615b606f45616bb07404680"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "203e30209cda8348420b75337e08f9695a6781b672916c667078ac5b1c708832"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e6b2c5f22860d3448ada7af8a3a719ac7a6f1392d0463ea10d30b7b3ba21f23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af55d41a616a1cc8ab9fbdff32a02b6c64e31a1769f6d37164be92abc84caa8a"
    sha256 cellar: :any_skip_relocation, ventura:        "f325336668599309ca11d7d943f29e9ab3f932795370cd1625cb2cb3e710a20f"
    sha256 cellar: :any_skip_relocation, monterey:       "5fe12d409d0964ef08935b149a1b0a3661a8246f7aa9e30edfc2cbc8c8979ee6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4a10dbb697add9b74c2704e39a2e3738151a828b403825909cc59204148518d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eb86a8d3cb6c6102fd087859085a7f3a61fa8b273c51dd10fecf44b0bbf820b"
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
