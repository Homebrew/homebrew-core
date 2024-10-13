class CloudformationGuard < Formula
  desc "Checks CloudFormation templates for compliance using a declarative syntax"
  homepage "https://github.com/aws-cloudformation/cloudformation-guard"
  url "https://github.com/aws-cloudformation/cloudformation-guard/archive/refs/tags/3.1.1.tar.gz"
  sha256 "ee870572b4b5e943a42c452c755c7a8af49675794b738051b8a63aa284695276"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "08c62a7e48efab86f6b8a3cb5db91e9cdb7a8002ea7a4e2e0d10704ed58c1cb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69df0ef961736b2539d92dcdf69a9c99567d71f477f5b43c836ab7b150d96869"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b82ecbceaf9cf79e11b6c34e08019467a71c61804099c060bf4ec499a174c861"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dfca33d74c6078b054a611495e07c51b66c42d60c5a269f21e48877654e6afd"
    sha256 cellar: :any_skip_relocation, sonoma:         "76ee3e3e239d94dc811b58625d691207efedd427630d2e386d861689c93bbddf"
    sha256 cellar: :any_skip_relocation, ventura:        "af5a5b8c5ae48f77786f47b9cd142d0056912270f85e35670bb91d7b8100626b"
    sha256 cellar: :any_skip_relocation, monterey:       "052eb9cdaa12167fb31fb4d276960b5eda60ff38aafeb9cd5e7c23080f60c4e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51ad19d2266387ba1ba3d5c99b6ef1baf3f03606de7c46b2dc077cddc703bbfd"
  end

  depends_on "rust" => :build

  # build patch for `unused return value of `must_use` that must be used`
  # upstream pr ref, https://github.com/aws-cloudformation/cloudformation-guard/pull/528
  patch do
    url "https://github.com/aws-cloudformation/cloudformation-guard/commit/4fa3ffe30ea164ee9d508de71024ca4fd0366dad.patch?full_index=1"
    sha256 "bb3cd7128801e3d41f410a39dd63d336570bb3060f61fa80e7d70067f1744f1f"
  end

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
