class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "37fb974ee0eb36ceb80f38f13141883f3779a81c79562d0ad15afcd74753485e"
  license "Apache-2.0"
  head "https://github.com/aws-cloudformation/rain.git", branch: "main"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5031fcf4faff28bc4346d2bc96a9e9a86700fa97400cad285a223e245c94a468"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5031fcf4faff28bc4346d2bc96a9e9a86700fa97400cad285a223e245c94a468"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5031fcf4faff28bc4346d2bc96a9e9a86700fa97400cad285a223e245c94a468"
    sha256 cellar: :any_skip_relocation, sonoma:        "04a3b06b6d14ed8c797ead0b5c54d88c272be22869fd7c1dd6186eae7d3853f2"
    sha256 cellar: :any_skip_relocation, ventura:       "04a3b06b6d14ed8c797ead0b5c54d88c272be22869fd7c1dd6186eae7d3853f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75e873fb45886368b0cefb0ed08483b03148202a0a0ce934c7dc4754102e450e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/aws-console"
  end

  test do
    # No other operation is possible without valid AWS credentials configured
    output = shell_output("#{bin}/aws-console 2>&1", 1)
    assert_match "a region was not specified. You can run 'aws configure' or choose a profile with a region", output
  end
end
