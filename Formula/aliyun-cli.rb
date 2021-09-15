class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.90",
      revision: "53042da35bce68987fd093b58d40845586daa137"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e3f92cd980e7d19b37f3432a7977b1ef0becda58360c8233ea0f81ce00096045"
    sha256 cellar: :any_skip_relocation, big_sur:       "5222b413f27bc704c193de4dd550d3a6fcef7b9bf3cb62dc1a4216facfad4126"
    sha256 cellar: :any_skip_relocation, catalina:      "6fa0e9ed36e821889e57f0160fab58a65d16428bf0d1915137860eac5f5128f2"
    sha256 cellar: :any_skip_relocation, mojave:        "3058e2f9ac87dd5c28cdd6226bcb02b3378dc6db0873fa4e5fb1d1f6fc9e5fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dc925ea9a6c22804864b3b7725c889dfadaa7eb0a3fdcb72c68b48e3618c494"
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
