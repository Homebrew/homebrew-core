class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.3.13",
      revision: "cd356adadb3aed447de9ab4530d307848fb7d49e"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59e9484b70db47451e867deac1ff06cf5b7442965e2d4820bb0fbdc43fae809f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59e9484b70db47451e867deac1ff06cf5b7442965e2d4820bb0fbdc43fae809f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59e9484b70db47451e867deac1ff06cf5b7442965e2d4820bb0fbdc43fae809f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bd95cf6bc003924c80caff087c7cab09f8f4fea4584609091e580956d43bb9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53e659700302f654a0a97ef4d547c92e6bbe667e4a5cbef0071f4c5d770240a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47228cc8e192aa22d0d10d412fb6d15081632bbbe9e5a670a5811bb0673193c0"
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
