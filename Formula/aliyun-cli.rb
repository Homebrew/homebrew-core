class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.94",
      revision: "48a0ebf6c0ff0444590c15aa83d328103b634170"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "75937ac498f0f3965793dec8e8e5a2bf74d5d5793d7a34fcc773a5b22577918f"
    sha256 cellar: :any_skip_relocation, big_sur:       "92f391e202e07ab9abcb976101a89dd533287321004b601fbfb745fd42ea8303"
    sha256 cellar: :any_skip_relocation, catalina:      "ee09c291bba8a02e89417e0211a417f6da25c4a2da426c2e3573ba46857e55b9"
    sha256 cellar: :any_skip_relocation, mojave:        "cd0bdb8322f3e78a4a4b8317bfe7a8f9df69f9d8cee840b8239e4b6fed9cba93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49b613ad365edf7fa0ca63dc7c8c7ff67bdb8e1ab1a103a5c92eb29fbe96bbe5"
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
