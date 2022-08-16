class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.124",
      revision: "00fb37e8f24adc43f000191c01871b86a18d0e1f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b6ea7799bf51fed9b73228b198a44e017509268a71db69090eaa8679e5bb506"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90440aaba69fc95aa6c30e758c014593aa1632d8df0639851b507adb94582199"
    sha256 cellar: :any_skip_relocation, monterey:       "41bf22fe48f7dd884be5b4ca25e30d6354e648b5fce1635af8e53e82e4b2a12a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbafaa8a9ba0c4507adc61938f5f0ea8c2d771d044d5fbd43b7f79afd4c60f26"
    sha256 cellar: :any_skip_relocation, catalina:       "bb599114e439ffa5117b079736f1800b2895dd5cf2c6094ec4723fc20971c6f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9539f4a081b9d09e4f3a9c3e673d7a2773004394a0b80070323571bda462332"
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
