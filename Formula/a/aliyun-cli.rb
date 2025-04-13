class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.269",
      revision: "0e8a9823f67033b2c9fd2b4015e575d77b36fd6c"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18b4b80a156785db189f84e8204b40d1d3ae0783b32477ffa9b0e0fed1785074"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18b4b80a156785db189f84e8204b40d1d3ae0783b32477ffa9b0e0fed1785074"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18b4b80a156785db189f84e8204b40d1d3ae0783b32477ffa9b0e0fed1785074"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfe0e7183f1d93aaca3fda216f0343d0d56df93797e42bf149c8f2d1a6016db0"
    sha256 cellar: :any_skip_relocation, ventura:       "bfe0e7183f1d93aaca3fda216f0343d0d56df93797e42bf149c8f2d1a6016db0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0b8aa641d843c178d2d77b7e5c7b07ca9adb2640180529ff191e07460590d5d"
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
