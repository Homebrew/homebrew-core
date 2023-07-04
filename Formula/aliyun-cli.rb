class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.168",
      revision: "502716b336cee534e107518f74a42d688c756014"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a00c08ab9fd9010ab2161ecf01164ff410efe26a00255b4cdaa524c931204037"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a00c08ab9fd9010ab2161ecf01164ff410efe26a00255b4cdaa524c931204037"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a00c08ab9fd9010ab2161ecf01164ff410efe26a00255b4cdaa524c931204037"
    sha256 cellar: :any_skip_relocation, ventura:        "54f4823099b0a18f0797ca7ccd058ecbc579d61099bd7fd00780df5f3bc1908b"
    sha256 cellar: :any_skip_relocation, monterey:       "54f4823099b0a18f0797ca7ccd058ecbc579d61099bd7fd00780df5f3bc1908b"
    sha256 cellar: :any_skip_relocation, big_sur:        "54f4823099b0a18f0797ca7ccd058ecbc579d61099bd7fd00780df5f3bc1908b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3cad778c79e446b891ca0758a2f2cdc1ec9e39447a1c797f72e8d5aa9c419b6"
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
