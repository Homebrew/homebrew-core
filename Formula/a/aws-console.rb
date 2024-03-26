class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "47ff89511181b9e79abc1a9491d551417b66a515f32c09bd5b278aeba3a03937"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de86eb923122ed29f4bc16f0301834b02d36142d297068fd01b81fa6d0ee7011"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ecd72ab1d34fa4eea0e80f39106d56b48776d4a4f3a017ebab33eb6d535845d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "930e6e33eb43c1179b55a39a71b6f13cc51e8b8248530c393060df9d4d5b3f3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "cea22c64e652c9d41fe42b1d45de5a30407222bfa9868b05bc6613d8570bf60b"
    sha256 cellar: :any_skip_relocation, ventura:        "cb3328417b6b4aa1292fbd0a0822f8a94768cb8fe079ffa34a145e6ae6218bf2"
    sha256 cellar: :any_skip_relocation, monterey:       "67aa1e9e88c4eae56f4a9902dbb955a2840c56fcddc7f69669c359038b5fb393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40ba18519daffec69cd9f6153d0c135379b188a11826bd2f4bab231bcbdf6f03"
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
