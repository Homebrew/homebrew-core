class AwsConsole < Formula
  desc "Command-line to use AWS CLI credentials to launch the AWS console in a browser"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.4.4.tar.gz"
  sha256 "e9cb12dce01fd38c2a642fb5850db7ccc3c77d22e135449430279ac061c7a61e"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e8137cbbb7775928e54863dbb5b2bbb67a411be5b3147481dd02f8b2a8bd666"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e8137cbbb7775928e54863dbb5b2bbb67a411be5b3147481dd02f8b2a8bd666"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e8137cbbb7775928e54863dbb5b2bbb67a411be5b3147481dd02f8b2a8bd666"
    sha256 cellar: :any_skip_relocation, ventura:        "6769e2d8ce2b807034b1dbc357aa76edec153e9aba0f10b2df4f3e0f5909c703"
    sha256 cellar: :any_skip_relocation, monterey:       "6769e2d8ce2b807034b1dbc357aa76edec153e9aba0f10b2df4f3e0f5909c703"
    sha256 cellar: :any_skip_relocation, big_sur:        "6769e2d8ce2b807034b1dbc357aa76edec153e9aba0f10b2df4f3e0f5909c703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d60b8960a777e933044e701902ea21cbf5425257c9865c05d2c943d54821c3f"
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
