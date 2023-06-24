class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.4.3.tar.gz"
  sha256 "b77b985ee964f794030b3c1ed0b16f65680fffba1e24054e02cffb0e1fb91602"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b74b15c8e5d5185fb9649348e7e16914266fda3d5af54a8eb66afe8018644e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b74b15c8e5d5185fb9649348e7e16914266fda3d5af54a8eb66afe8018644e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b74b15c8e5d5185fb9649348e7e16914266fda3d5af54a8eb66afe8018644e8"
    sha256 cellar: :any_skip_relocation, ventura:        "f921d11893cbace9f6ca8bd761f21d79c4d9f12a370a117ec49945842e6ad5d4"
    sha256 cellar: :any_skip_relocation, monterey:       "f921d11893cbace9f6ca8bd761f21d79c4d9f12a370a117ec49945842e6ad5d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f921d11893cbace9f6ca8bd761f21d79c4d9f12a370a117ec49945842e6ad5d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "849556f9454bacafa6cbce4f75508f7b045a26981af449446fe617135434b4fd"
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
