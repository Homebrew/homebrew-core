class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.302",
      revision: "11f2565121733a4b06b142885f965f4fddcf1a8f"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9793271a75a1f9af2f6538a4745803cd607c0ef4216e8e79e84df632991fb872"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9793271a75a1f9af2f6538a4745803cd607c0ef4216e8e79e84df632991fb872"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9793271a75a1f9af2f6538a4745803cd607c0ef4216e8e79e84df632991fb872"
    sha256 cellar: :any_skip_relocation, sonoma:        "5038b18c32c0776edabbe703b8441234bedfc6ef96d9d1198597ab5e612ebb75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c68a00f62654586bdff4a1a072515f5c9d5099db3403d2adb8c6953e2dac3831"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "main/main.go"
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
