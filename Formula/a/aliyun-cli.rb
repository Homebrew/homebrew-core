class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.199",
      revision: "5faae09ac5306afba588d4f230855359a6b086e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f4382267e923abb2c27587ab388d88a0d089157e76e401c5419ea05c6c2346e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad49ecec4c80d5c069a5d5ebee70ede96afdc2a64d5668a333daf986daab1111"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebc1d73098843b9ddbbc944f89041e90627bc10dea399e6f5f31a818bd8faeff"
    sha256 cellar: :any_skip_relocation, sonoma:         "0972ebc5cbf4562c527e864f63b0597e7a3489aaf3afdd778f555fdeb6dfbc1a"
    sha256 cellar: :any_skip_relocation, ventura:        "8361ab015748ec45553550521afcab4dc2c981b874eb41c0212c7589a01bfe80"
    sha256 cellar: :any_skip_relocation, monterey:       "37ed42d77d02a0abe38ca8dec8d5162fe426b598158b0a3c1e29d7dc4185087b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abc17c9908c6e1fb8b0ca751480dbe4efb08c59bb9e0933240d438afd692c066"
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
