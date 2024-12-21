class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/refs/tags/3.1.12.tar.gz"
  sha256 "089a6268bb97c49edef45d99e5730d4c3cb0febb2a2f5ba38e2558568f685461"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c6b065811bdf93dbb06dca229b3567045a25420cecf828554efc9ee49eddb48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ab0907195c7ae28169278e5274755b2affe21fc43ec24fb15bc90fb722e7d3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e3a03945d1830b0118ce9a305347d0287b06e0d664552f6cc16ffb9a289d609"
    sha256 cellar: :any_skip_relocation, sonoma:        "418c4452b9314131ffb0c60433b5f1451207a7875fefdbc8054421661425106b"
    sha256 cellar: :any_skip_relocation, ventura:       "8903293b6db67437a424372618aae457b596c26fb5e09c8499b32457287b349e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97922a5fb353ad0da865d66940eceae6268e5648f82411bb8377a4a56ea78a23"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "guard")

    generate_completions_from_executable(bin/"cfn-guard", "completions", "--shell")

    doc.install "docs"
    doc.install "guard-examples"
  end

  test do
    (testpath/"test-template.yml").write <<~YAML
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
    YAML

    (testpath/"test-ruleset").write <<~EOS
      rule migrated_rules {
        let aws_ec2_volume = Resources.*[ Type == "AWS::EC2::Volume" ]
        %aws_ec2_volume.Properties.Size == 99
      }
    EOS
    system bin/"cfn-guard", "validate", "-r", "test-ruleset", "-d", "test-template.yml"
  end
end
