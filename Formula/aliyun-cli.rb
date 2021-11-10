class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.99",
      revision: "a14b5503f993f0c45ec2f7b3512d9d33b5b3d096"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc5e88032ee455d7d4f4ed89ac70a4aed08ef8d2fc95e67cf55910c1a157289b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32fb6994a116b48f34eb64efd747aedbe4e9ff82220495bd4930c24193c2c0aa"
    sha256 cellar: :any_skip_relocation, monterey:       "c085863c4ad43aa2ce8321d46801b54b8c57e18918d06b3460e91cfcbb0f5877"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f40288f737944827219ffb66f957eeba54a15fe365664d7a33d8d7c6d6ffceb"
    sha256 cellar: :any_skip_relocation, catalina:       "e6904cb31570cfb383ad605eaebee82515445cf3c2bd75a927688e13328e0689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "957eb4620035e38e6c764fcce06dd0a463d33eddd341554c0da537b5ef9742f0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"),
                          "-o", bin/"aliyun", "main/main.go"
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
