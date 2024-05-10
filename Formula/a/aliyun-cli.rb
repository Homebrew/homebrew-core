class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.205",
      revision: "aba22ba463d6af2a2bf1a7d8d1a50a08969aaa7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ccfb0115a5c619469639920569136b73cb4054a828c01ade5c7c00d7d094e92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29808e2e4da76e93fc8ebeae98e952542b18302707828454065c235535310a8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e86f8ed54432996ab9a8b21ed052c049e6c10c6980e7033310d88fec094cb8f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f009d259c9cfcd005b7c68d6a9069d58759d07018c038614321f66b81057fb21"
    sha256 cellar: :any_skip_relocation, ventura:        "2fa99a3aa19f719cebef9b62de7027c6bde2b9369fe7234c30039b78d906d50c"
    sha256 cellar: :any_skip_relocation, monterey:       "93c334829fe5c8316f4a1b7726935270004f3038eadf42f65848fe2e5b33bc7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6d4fa7f5da533d8e74fe8734f7ce52461c7151029439e9a2ed3236bea131d37"
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
