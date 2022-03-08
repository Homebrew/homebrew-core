class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.111",
      revision: "7e290f756a5bc6033192f1409a2fd837e0e68b80"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "368d652e5b10301befbe261940223e403c0e1f476db84ddc795f9abacc572acd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7358120781c860561b650b7584b24b51c80b44b681275a2b0c8cb68abaa435b"
    sha256 cellar: :any_skip_relocation, monterey:       "aa1aa2d550e159e7f2a7e9cb563d0354e7187ba41c3ddb9d43913a427945caa1"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a0fa901dee5b3fe454cb693369c5d9224fbdc183c7aa3e7b5fc5043806a42e6"
    sha256 cellar: :any_skip_relocation, catalina:       "5d9f9a435b5afcfd9504a965e62ef349993081be7f1e060bef5f01a878266a34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f02ead19c1f7cf51f5bd94cb265042efd569120addfb6f78ba55ba00f9744d97"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags: ldflags), "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
