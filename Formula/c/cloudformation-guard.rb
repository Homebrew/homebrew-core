class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/refs/tags/3.3.0.tar.gz"
  sha256 "9e4ba38bdf59205e450998b55fb2e08dcbada0fe254384d9915fb6dc302cf448"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e16cd5b0f9bfd6162ead1d9a327992e3779632c148b939c2bc595bd12b9bb741"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc7bbb3f51b1d481e0bb89ffc9eb321a29b54daddd1708e50bfd7edd4edcaa04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "02d8076c1eabd89e16729b91fed62a4761d0261698f9f5c2529c05091e734a17"
    sha256 cellar: :any,                 arm64_linux:       "5f7e8a60dcd9889006c2ab0400e39ebdf1e1df153b7bfbebee5915e2e4e982bc"
    sha256 cellar: :any,                 x86_64_linux:      "bf305b56bad4bcd43e510211d92511a69ef36700e890139ffadab0c9769fe9ee"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
