class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.110",
      revision: "ae1fe5444acc5717bcfc2dfb816f6446180dc42b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f5d0490aa2a32d0156d573ec9a45b5cedac8c9e1562c4ade4990c3f2c309494"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "298b3406011ec082ae187d14b970368c9635816324536a3789c9133519423aa0"
    sha256 cellar: :any_skip_relocation, monterey:       "e6cf9ecb433f2ca2f5380410b6b6d1c874829594fee2869cd61b2332eaf87368"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c50dd9aa5be58dc9a152d112651fc7e2e2f0d0deb29a78ee824445ce15fead6"
    sha256 cellar: :any_skip_relocation, catalina:       "740e492a66c144c8863afe08b241c21575a3771061aa474653575c43684af104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4180126cbeefab56be9654a607bfcb7012314522d5ff4691b0d6e18d8111d36"
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
