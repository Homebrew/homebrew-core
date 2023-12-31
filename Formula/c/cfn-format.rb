class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "8d3390658664a60b503c85ebf23d13c07b0defdbd29933f564aca03ba986e3b6"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36c4257778cafedd6f5d934ea0f7cb0e8edfefcd6364657e6b9a035919d9a807"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27bdaccc5cddc17caeff92340d90b19c121f23fe43d5bc93d9099c971a286e94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e166c21f65766802d9860e7429fd09a712ec4ede823e457513c472240ec7f83"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ca6fd9fc6f687980647251664892321c96be56bee10259bbc1bd8f1b2901b10"
    sha256 cellar: :any_skip_relocation, ventura:        "d46b098bee4aa528b743c11d8e60eda8d3fcd88525f5e443fa98a43e6d64bfd4"
    sha256 cellar: :any_skip_relocation, monterey:       "3d659cd67cf3d768c8b78e0ca11c9299bb838a8e938b63f749b15950436404d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be119700175dfdb0a96e6342692e2346487d2b4cd686aa90a8fe43b6f6255ff1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/cfn-format/main.go"
  end

  test do
    (testpath/"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}/cfn-format -v test.template").strip
  end
end
