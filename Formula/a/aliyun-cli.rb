class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.227",
      revision: "fae82413e78a15352e78654a6c966447d7180ee3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f7b4a8c0378a1f4938f2e1326ccbb801c2a8f23e4bfce0959fc203609e14dfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f7b4a8c0378a1f4938f2e1326ccbb801c2a8f23e4bfce0959fc203609e14dfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f7b4a8c0378a1f4938f2e1326ccbb801c2a8f23e4bfce0959fc203609e14dfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8969cbbd2eec0a5eccff9cb4f43f09d65d3ce8a4c968e79870a722074c8803e0"
    sha256 cellar: :any_skip_relocation, ventura:       "8969cbbd2eec0a5eccff9cb4f43f09d65d3ce8a4c968e79870a722074c8803e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d2afeeb0ac357c3450c9d88c797a60e5e712d04be95ebdc5b6308e08bb7d103"
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
