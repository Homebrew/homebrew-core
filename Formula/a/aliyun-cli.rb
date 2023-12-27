class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.191",
      revision: "39556a38a6dae2356c98caeec07a63f67ca2d4db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64f8099db93e7a20dadd2ee2d20a0ae6e67333854186ee6504c878ea17020f8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73847bc0b7ffaae63dbb8b7049bde74e33384ea176da8113bbb485c8096f6b44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "886c06270c82df9010c0f035301127b4371852cd7d6076f1745a976447da5624"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f50fc2ac5c70048215035f9bf29073902899b94600e8497bbcb7fc5440ee4fc"
    sha256 cellar: :any_skip_relocation, ventura:        "ba1c59144ca54fddf5169cb3750e3766e6bc15ee861e8a547c08aaf21a79c0b8"
    sha256 cellar: :any_skip_relocation, monterey:       "3edca7b325db41b9d095073819f673175100ae124682aa357b5dc6bb208780f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d8ec7c5f7d4127fb1b16d5a9910d5fe744428c1176324eb939149864e7314e6"
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
