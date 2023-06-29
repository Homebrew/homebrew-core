class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.167",
      revision: "b326e32d0d908addd0489841e059e459595e2897"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01f19e54b89f823a07296e69c1ab961ccdeeb3f1e2b339781f3f32511fc1bea6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01f19e54b89f823a07296e69c1ab961ccdeeb3f1e2b339781f3f32511fc1bea6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01f19e54b89f823a07296e69c1ab961ccdeeb3f1e2b339781f3f32511fc1bea6"
    sha256 cellar: :any_skip_relocation, ventura:        "b4de3aac28eeb91c0cac8c19a2b96262a0350be8730b2edcdc16b7b673d0ba22"
    sha256 cellar: :any_skip_relocation, monterey:       "b4de3aac28eeb91c0cac8c19a2b96262a0350be8730b2edcdc16b7b673d0ba22"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4de3aac28eeb91c0cac8c19a2b96262a0350be8730b2edcdc16b7b673d0ba22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc861063c04ec9485dca98517b0db0745be502c957ef73bef0860abab4874e87"
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
