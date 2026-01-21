class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.2.7",
      revision: "87b469e8fbf5064e26cc05bdf6baf4330f65bd21"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ce5c1211696040a4e1a6a3e02616d5ff8ca3ee4e7ca72410f5c6db86a2e395e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ce5c1211696040a4e1a6a3e02616d5ff8ca3ee4e7ca72410f5c6db86a2e395e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ce5c1211696040a4e1a6a3e02616d5ff8ca3ee4e7ca72410f5c6db86a2e395e"
    sha256 cellar: :any_skip_relocation, sonoma:        "770aa168bf9a4881f3e51c69414a63bd9d85ca320064d8d9304871c0f4fd90aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aaa68a5902b38b8eb4a72622e0047eeb2f3571413eadb821dbf542cbf41c570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44b52c4e80e645981d26605c14c717d482c6c53b3aeb505a08e6de631653b08f"
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
