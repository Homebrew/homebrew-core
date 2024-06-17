class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.207",
      revision: "bcb078372ae7381955ececa3b59a09b2c9bd87d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61cf7aa95af6aacaab48ebc2467d73eb3a87181bc2387e5f6d2ff5a5558e90ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e513103b4b2249311ce23c7662d734e3053e9d09116940515920dd5c270e77e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f6bb37f5dd75e60758a80fa50f5658373c00dce2201f1c549d6c964fa72fa9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bfc45af69114821932d41cdba38fd2582b15d261eda77920e35d649bf96550b"
    sha256 cellar: :any_skip_relocation, ventura:        "1670bc8b124320a22229520ee0c8462442ae06327e09691a0f5d88222969fa0a"
    sha256 cellar: :any_skip_relocation, monterey:       "0c4b0036987069e152a43641ef676ed967a7a7b172365286a91598c9dcc5be0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0da11dab71b884a631b9f57d77752047718cb5baf0b52be5aa29c06dd4f0a51"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
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
