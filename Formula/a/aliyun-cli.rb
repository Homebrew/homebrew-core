class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.235",
      revision: "923f9f3636f5383dfd8392da777bc5f53fdc7d68"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46150cbbe27810108ab6f15522d7e3717e63edeb0c3c585f6a4572f80f62d75d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46150cbbe27810108ab6f15522d7e3717e63edeb0c3c585f6a4572f80f62d75d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46150cbbe27810108ab6f15522d7e3717e63edeb0c3c585f6a4572f80f62d75d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e20fd5126233192c6ae7e23836e37013f5db5fb607ff5c6dfa7b9579773dafcc"
    sha256 cellar: :any_skip_relocation, ventura:       "e20fd5126233192c6ae7e23836e37013f5db5fb607ff5c6dfa7b9579773dafcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4749f4de570f4ea93513beec3b5bfd6537bf95f60cdf273399cb48627934108d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
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
