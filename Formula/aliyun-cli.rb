class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
    tag:      "v3.0.82",
    revision: "34a7ab8bf36ff9121f21b838d7c1259edd17cb43"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1b8b3e9fa621f7d1973418c29678d8dab915183116363fb57586f3d00dae8e0f"
    sha256 cellar: :any_skip_relocation, big_sur:       "75a04a700fa34534a47fbbc09b8e43a01db5c098a408de29047cdea7f9caec67"
    sha256 cellar: :any_skip_relocation, catalina:      "28cb8aed86428023757746703178ebc2ca64b551deac995a8aaf48b2a24bc93f"
    sha256 cellar: :any_skip_relocation, mojave:        "93d52a697456ae5949bef1b6ae8abb89bddf5b9242cfdcb89408dec15dffe25b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "831ea3e8913c867c2d5993a3d69158d2faeb339f2c61813dd559ae7c9c1de36e"
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
