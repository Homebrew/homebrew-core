class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.151",
      revision: "feae19f6a7470243706da9fca717faa19fc06e1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7588d78c551f75aebd456da048705998c4a45440fa03cf99b3440809e111e7bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7588d78c551f75aebd456da048705998c4a45440fa03cf99b3440809e111e7bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7588d78c551f75aebd456da048705998c4a45440fa03cf99b3440809e111e7bb"
    sha256 cellar: :any_skip_relocation, ventura:        "cf11f900c3f9bd0b2da1dfe785000cd50e75f7384f72e836b52d597ff3f2b3b4"
    sha256 cellar: :any_skip_relocation, monterey:       "cf11f900c3f9bd0b2da1dfe785000cd50e75f7384f72e836b52d597ff3f2b3b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf11f900c3f9bd0b2da1dfe785000cd50e75f7384f72e836b52d597ff3f2b3b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c47da166ed8113a0e407ec8c00a057097aa78e6bbb2b1317c03c643367da6350"
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
