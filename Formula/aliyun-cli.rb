class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.127",
      revision: "0afd3fbe0cbc1b6a375add45ed896454c21cd53f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ed52a27328b3c8aff314f80b2277f5ef138a086d257f1d0a59b4927a809ddfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bab94285391dd16d2c1c24b2bfde0581c4cc0282a302a95e83f8595cd90ce36"
    sha256 cellar: :any_skip_relocation, monterey:       "75db69e2dee2de84f2a35c86d0bf9052d09d31073bf753eac523bb5b07cb80c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "41114bf9be5a62f963f97f1d784c2708da1610d3c3d2951d67a74ce9cc0c6042"
    sha256 cellar: :any_skip_relocation, catalina:       "81e1f64475a1c99a6027adfc3c62313c69f26aabae94693df7abbd7866ecf07d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "206d6e9413dd423a78f0dbb1e3452bfb252834a01a75e64f31279af3bfdf7124"
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
