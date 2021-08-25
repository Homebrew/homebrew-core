class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
    tag:      "v3.0.89",
    revision: "b2b1c46958f169322bebb59775806b19a43937b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4cb225ee1042e72e446fee7178a0f4eaa8bcef77d601ba822f65f1c9e910b500"
    sha256 cellar: :any_skip_relocation, big_sur:       "c4e3103b3786ffc31e013e5350931bc01583943cf514ef83e2ffaddcc931dbd6"
    sha256 cellar: :any_skip_relocation, catalina:      "01811acba81fcd334d99e96f67477bb3ee5226700627ba637b96a7db675e08af"
    sha256 cellar: :any_skip_relocation, mojave:        "c67fe48f1a93bc373a13b162844564dee7da0bcfede300e55f8a34ccfffdc3df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c8214e30e003839d58bc54cc77718390fe5d8a8c9b61d340917542f38e135fe"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "metas"
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
