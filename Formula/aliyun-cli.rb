class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
    tag:      "v3.0.88",
    revision: "017637745ad7ae86c5422f1f9e2e6d78771bd080"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "86208d67defbddee448d79be22e4c35411517e623632c6032bdd0208cc52e623"
    sha256 cellar: :any_skip_relocation, big_sur:       "f8938387a105d78b4b7108eb75017e3cb92829ec6e67d2d9b673bda077797080"
    sha256 cellar: :any_skip_relocation, catalina:      "974f583da80ee68ed89e22db2129925130d066efebaa63c7b193fd996369b98e"
    sha256 cellar: :any_skip_relocation, mojave:        "86252772acdc7d2aa107dcee3e03ff9b4e7ff62c1ca91329f9b7ee2525c714f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0353b4fe39fa28bd4ecf7e83abe46d2dea44d5f5ef1dbe583ad2f9af80b06283"
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
