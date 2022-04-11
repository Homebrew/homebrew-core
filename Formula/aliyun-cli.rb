class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.116",
      revision: "292b98951253aa7f030b46a12e5d797d2a57cc07"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe67edd73d6e4eb04a7f4a1a2728c1ce344df9cecef3760f396246012015df8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0d399d3d2e54b6b725aa292e7db169b4211ea32bcf96547b632b4b3dad14ae8"
    sha256 cellar: :any_skip_relocation, monterey:       "46cbf9c8fa712fa670e63e96113dc13ed31b5ce8f9eea09cb3de38f74cf9c2b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "75c1e7c2b8eabaa65afe2c8105917ef6c292bd5cb74f5481741f0e7347a4f126"
    sha256 cellar: :any_skip_relocation, catalina:       "8b9094982a863799cfe441d447a94d1efa93b2f1455457042d558902a5b244b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae50163b8b34bccc6a77b30bdfb98784052b6fb1fc196b13aaaebbf63bc36452"
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
