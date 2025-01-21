class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.249",
      revision: "863b2f765cace6bfc40916b15fcb769ce8d0bc19"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c42207fc3e1f70c664a5c5b56396001d099a35bfd0ecf7113d779a0f40b63058"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c42207fc3e1f70c664a5c5b56396001d099a35bfd0ecf7113d779a0f40b63058"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c42207fc3e1f70c664a5c5b56396001d099a35bfd0ecf7113d779a0f40b63058"
    sha256 cellar: :any_skip_relocation, sonoma:        "e10ddb2090024c6e62c380d46f39008728a9cb5551f205557b329fe34eb7dc8c"
    sha256 cellar: :any_skip_relocation, ventura:       "e10ddb2090024c6e62c380d46f39008728a9cb5551f205557b329fe34eb7dc8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90b970b16207a443ecbcd2691120df0de799953fcda728ce95db2a0a34cea528"
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
