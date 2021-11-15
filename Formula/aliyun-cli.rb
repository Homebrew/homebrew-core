class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.99",
      revision: "a14b5503f993f0c45ec2f7b3512d9d33b5b3d096"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07238d85d1bef7587132e1e14136062c15d625176240654922ab476dff3e48a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ea094b9861d3b2c2863cf67b9ac434e03fca4a5437526d58bf21711170e7bc6"
    sha256 cellar: :any_skip_relocation, monterey:       "10cf69bf26d2e152ec54d0f87c6d6cf9eb12c0560efa44920a82f5430ae0fa7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8dd2283edef05bdf70ae37a08b36764e093435d852c74a4866f2dcf6b8adef36"
    sha256 cellar: :any_skip_relocation, catalina:       "dabf5c5d24ec8c9dd8f3ac61e51f8371a426089c0c06c9f3510b24501fb96e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d300be43328df4de1f40fd4e230286603e314733ac3fcf448be587139966207"
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
