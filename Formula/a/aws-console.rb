class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "dccb0ca38f914ef450c422cd27423f1df2c2abf25fc3e58ab388d08efdebe762"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7eab174d07e4f39348782679f00f21b2bf71f93c9045982c26ce618adbd71f51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1f53fea732fa0dceb953eff6c04af009999dd978e6c338af8e8ac01fd0b4730"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fae4b77efaa395cab2fa6b34009445c58ce2de4283d26ad7cab1c6af21494419"
    sha256 cellar: :any_skip_relocation, sonoma:         "97b672fff16f27f379a86a8125d300fb8e8bb147aa020f0a5e6eaad658606c59"
    sha256 cellar: :any_skip_relocation, ventura:        "4bf8b0776c390954d213946e7f3ad1a46297131a67f9f76b1a9c52b199e61ebd"
    sha256 cellar: :any_skip_relocation, monterey:       "5851f440e7dee61e34b9a6463c11f311081ba0e52794bafe710e0fe69b83283a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4a136f91f3041b46384a9711125d411575b6721e398e0ba6ac8abd9f464e374"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/aws-console/main.go"
  end

  test do
    # No other operation is possible without valid AWS credentials configured
    output = shell_output("#{bin}/aws-console 2>&1", 1)
    assert_match "a region was not specified. You can run 'aws configure' or choose a profile with a region", output
  end
end
