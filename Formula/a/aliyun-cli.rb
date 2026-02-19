class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.2.9",
      revision: "5de5222567331056aeffbf46f55605fa8d5212ca"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ad55d5d47547420c34df2209c0561b852c8ba83023b786f868e1a6966b11fec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ad55d5d47547420c34df2209c0561b852c8ba83023b786f868e1a6966b11fec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ad55d5d47547420c34df2209c0561b852c8ba83023b786f868e1a6966b11fec"
    sha256 cellar: :any_skip_relocation, sonoma:        "49d94bf1b60ffa57d2b4bcd7b06328da1687424e31f7ecfa0e9adc22e1b2c892"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "060ffe7b1fd639254bae86de1c6e10d3152dd0f12d654d472e4338a82d79125e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6097a623e8ec6d47d98d5c1ee5be9c9e9aac9521f970ad155b22a4759217c4b3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/v#{version.major}/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "main/main.go"
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
