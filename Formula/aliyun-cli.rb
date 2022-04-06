class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.115",
      revision: "4502587bccf00c3766868d2638da60f5eac7ac7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5573e3d0328f51a110b8e3e43f35d36a40ddfe8c8c9d8d85b455e9eed4e34e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec13c972c23713042b11d1311e80d2a979fa760ff0a1cc0253e2a6a9cbb8ebf1"
    sha256 cellar: :any_skip_relocation, monterey:       "f841677519910219dcb08de17180d2b9653612c313433e979e8dfcd7397d4e28"
    sha256 cellar: :any_skip_relocation, big_sur:        "c48980e3de37785b99ab95dd2ec7f73ad638774b248894450b2097baf3d3b9ca"
    sha256 cellar: :any_skip_relocation, catalina:       "422a4d9eea351338558015de1e55e825b22a5e781cc84f805c2121732f9e9d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c7582286e7c43d49be723b18bc36b77b90692411c278c2d072f572e2361af20"
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
