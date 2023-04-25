class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.161",
      revision: "dc68f322e9784ff35d34051cb6b3429373826bd4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70d8dcf35199818b487a334b270643a73b0d10ed511760757b1e402f7a1e58c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70d8dcf35199818b487a334b270643a73b0d10ed511760757b1e402f7a1e58c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70d8dcf35199818b487a334b270643a73b0d10ed511760757b1e402f7a1e58c0"
    sha256 cellar: :any_skip_relocation, ventura:        "60b507da7f916dd342d9c421a429f704f5da8f2768f3c878bf56094e78726c21"
    sha256 cellar: :any_skip_relocation, monterey:       "60b507da7f916dd342d9c421a429f704f5da8f2768f3c878bf56094e78726c21"
    sha256 cellar: :any_skip_relocation, big_sur:        "60b507da7f916dd342d9c421a429f704f5da8f2768f3c878bf56094e78726c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c7e436a176a87aaf10d1d6914b235211a566bd3c2f0c6852928d04d0e63fc6f"
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
