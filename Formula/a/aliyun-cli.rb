class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.4",
      revision: "7971aeffcf810d79742f7911334a7fb1a11473fb"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ec3c02ecfdd1017e232236a3083628ca5eb4868e2193b1a6d29a734e7ace3dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ec3c02ecfdd1017e232236a3083628ca5eb4868e2193b1a6d29a734e7ace3dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ec3c02ecfdd1017e232236a3083628ca5eb4868e2193b1a6d29a734e7ace3dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a1f577728113334b5c8ee1721d02b0803b9d434fdda071cb3dcba4307f17c7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91a7cd1d34f8ca224fd16b7a722142a5f9189c67fa7c0d45702b0700a3b1135b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffed4602cc97cef865793c913a58bc8573fe1c291fe25352c88cccecae4061fa"
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
