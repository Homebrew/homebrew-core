class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.101",
      revision: "7575a1fabb236fae0f8f25536c2778f156984b16"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d20faadd713fc737bc645990ad598a25232626b13223036352f8e2981b4cdd3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03315dcd7857e40de4bc6a4bd9de7f3f7f7f76e6fff6346bc37219f3545273fc"
    sha256 cellar: :any_skip_relocation, monterey:       "cf8b942e0d9c94445516dd9667806d1865cc113759bd2aec69f6dd108997d9d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d752c57ac15b2833d29a241c3cd487d11f155d5185ba92ab241884bebe311719"
    sha256 cellar: :any_skip_relocation, catalina:       "e2afe291e640d11f5028005a88ed20ae020b03090ebbeb7ae15e40882d3c92a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9337164478c2eee24d8f93898945be7de7715a089a5b35878077a24c58300404"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"),
                          "-o", bin/"aliyun", "main/main.go"
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
